//
//  HomeViewController.swift
//  C-Cermmerce
//
//  Created by 양시관 on 2/12/24.
//

import UIKit
import Combine
//UIViewController 를 상속받는HomeViewController 클래스 선언
class HomeViewController:UIViewController {
    
    enum Section : Int{ //섹션의 종류를 정의하는 열거형
        case banner
        case horizontalProductItem
        case verticalProductItem
        
    }
    
    
    @IBOutlet var collectionView: UICollectionView! // 뷰와의 연결
    private var dataSource : UICollectionViewDiffableDataSource<Section, AnyHashable>? // 컬렉션 뷰의 데이터 소스를 관리하는 변수임
    private var compositianlLayout : UICollectionViewCompositionalLayout = setCompositinalLayout()
        
        //UICollectionViewCompositionalLayout를 사용하여 각 섹션의 레이아웃을 동적으로 생성
    private var viewModel : HomeViewModel = HomeViewModel()
    private var cancellables : Set<AnyCancellable> = []

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        bindingViewModel()
        viewModel.loadData()
        setDataSource()
        
      
        
        collectionView.collectionViewLayout = compositianlLayout

       
    }
    
    private static func setCompositinalLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout{section, _ in
            switch Section(rawValue: section) {
            case .banner:
                return HomeBannerCollectionViewCell.bannerLayout()
            case .horizontalProductItem:
                return  HomeProductCollectionViewCell.horizontalProductItemLayout()
                
            case .verticalProductItem:
                return  HomeProductCollectionViewCell.verticalProductItemLayout()
                
            case .none: return nil
            }
        }
    }
    private func bindingViewModel() {
        viewModel.$bannerViewModels.receive(on: DispatchQueue.main)
            .sink{ [weak self] _ in
                self?.applySnapShot()
                
            }.store(in: &cancellables)
        viewModel.$horizontalProductViewModels.receive(on: DispatchQueue.main)
            .sink{ [weak self] _ in
                self?.applySnapShot()
                
            }.store(in: &cancellables)
        viewModel.$verticalProductViewModels.receive(on: DispatchQueue.main)
            .sink{ [weak self] _ in
                self?.applySnapShot()
                
            }.store(in: &cancellables)
    }
   
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,cellProvider: { [weak self] collectionView, indexPath, viewModel in

            switch Section(rawValue: indexPath.section) {
            case .banner :
                return self?.bannerCell(collectionView,indexPath,viewModel)
                
            case .horizontalProductItem, .verticalProductItem:
                return self?.ProductItemCell(collectionView,indexPath,viewModel)
               
            case .none :
                return .init()
            }
            
           
        })
    }
    
    private func applySnapShot() {
        var snapShot : NSDiffableDataSourceSnapshot<Section,AnyHashable> = NSDiffableDataSourceSnapshot<Section,AnyHashable>()
        if let bannerViewModels = viewModel.bannerViewModels{
            snapShot.appendSections([.banner])
            snapShot.appendItems(bannerViewModels ,toSection: .banner)
        }
        if let horizontalViewModels = viewModel.horizontalProductViewModels{
            snapShot.appendSections([.horizontalProductItem])
            snapShot.appendItems(horizontalViewModels, toSection: .horizontalProductItem)
        }
        
        if let verticalViewModels = viewModel.verticalProductViewModels{
            
            snapShot.appendSections([.verticalProductItem])
            snapShot.appendItems(verticalViewModels, toSection: .verticalProductItem)
        }
        dataSource?.apply(snapShot)
    }
    
    private func bannerCell(_ collectionView: UICollectionView,_ indexPath: IndexPath,_ viewModel:AnyHashable) -> UICollectionViewCell{
        guard let viewModel = viewModel as? HomeBannerCollectionViewCellViewModel,
              let cell : HomeBannerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCollectionViewCell", for: indexPath) as? HomeBannerCollectionViewCell else {return .init() }
       
        cell.setViewModel(viewModel)
        return cell
    }
    private func ProductItemCell(_ collectionView: UICollectionView,_ indexPath: IndexPath,_ viewModel:AnyHashable) -> UICollectionViewCell{
        guard let viewModel = viewModel as? HomeProductCollectionViewCellViewModel,

                 let cell : HomeProductCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeProductCollectionViewCell", for : indexPath) as?
                 HomeProductCollectionViewCell else {return .init()}
         cell.setViewModel(viewModel)
         return cell
    }


}

#Preview {
    UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() as!
    HomeViewController
}
