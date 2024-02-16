//
//  HomeViewController.swift
//  C-Cermmerce
//
//  Created by 양시관 on 2/12/24.
//

import UIKit
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
      
       

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
       
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
    private func loadData() {
        Task{
            do {
              let response = try await NetworkService.shared.getHoemData()
                let bannerViewModels = response.banners.map{
                    HomeBannerCollectionViewCellViewModel(bannerImageUrl: $0.imageUrl)
                }
                let horizontalProductViewModels = response.horizontalProducts.map{
                    HomeProductCollectionViewCellViewModel(imageUrlString: $0.imageUrl,
                                                           title: $0.title,
                                                           reasonDiscountString: $0.discount,
                                                           originalPrice: "\($0.originalPrice)",
                                                           discountPrice: "\($0.discountPrice)")
                }
                let verticalProductViewModels = response.verticalProducts.map{
                    HomeProductCollectionViewCellViewModel(imageUrlString: $0.imageUrl,
                                                           title: $0.title,
                                                           reasonDiscountString: $0.discount,
                                                           originalPrice: "\($0.originalPrice)",
                                                           discountPrice: "\($0.discountPrice)")
                }
                applySnapShot(bannerViewModels: bannerViewModels, horizontalProductViewModels: horizontalProductViewModels, verticalProductViewModels: verticalProductViewModels)
            } catch {
                print("nework error : \(error)")
            }
        }
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
    
    private func applySnapShot(bannerViewModels : [HomeBannerCollectionViewCellViewModel], horizontalProductViewModels: [HomeProductCollectionViewCellViewModel],verticalProductViewModels : [HomeProductCollectionViewCellViewModel]) {
        var snapShot : NSDiffableDataSourceSnapshot<Section,AnyHashable> = NSDiffableDataSourceSnapshot<Section,AnyHashable>()
        snapShot.appendSections([.banner])
        snapShot.appendItems(bannerViewModels ,toSection: .banner)
        
        snapShot.appendSections([.horizontalProductItem])
        snapShot.appendItems(horizontalProductViewModels, toSection: .horizontalProductItem)
        
        
        snapShot.appendSections([.verticalProductItem])
        snapShot.appendItems(verticalProductViewModels, toSection: .verticalProductItem)
        
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
