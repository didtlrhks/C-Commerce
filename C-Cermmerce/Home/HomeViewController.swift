//
//  HomeViewController.swift
//  C-Cermmerce
//
//  Created by 양시관 on 2/12/24.
//

import UIKit
import Combine
//UIViewController 를 상속받는HomeViewController 클래스 선언
final class HomeViewController:UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section,AnyHashable>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    
   private enum Section : Int{ //섹션의 종류를 정의하는 열거형
        case banner
        case horizontalProductItem
        case couponButton
        case verticalProductItem
        
    }
    
    
    @IBOutlet private weak var collectionView: UICollectionView! // 뷰와의 연결
    private lazy var dataSource : DataSource = setDataSource() // 컬렉션 뷰의 데이터 소스를 관리하는 변수임
    private lazy var compositianlLayout : UICollectionViewCompositionalLayout = setCompositinalLayout()
    
    //UICollectionViewCompositionalLayout를 사용하여 각 섹션의 레이아웃을 동적으로 생성
    private var viewModel : HomeViewModel = HomeViewModel() // 홈화면의 데이터 처리와 상태관리를 담당하기위해서 사용함
    private var cancellables : Set<AnyCancellable> = [] // 콤바인을 사용해서 뷰모델의 상태변화를 구독하는 cancellables 을 만들어줌
    private var currentSection : [Section] {
        dataSource.snapshot().sectionIdentifiers as [Section]
    }
    
    
    override func viewDidLoad() { // 뷰 컨트롤러의 뷰가 로드될때 호출되는녀석
        super.viewDidLoad()
        
        bindingViewModel()//뷰모델 바인딩
        
     //   setDataSource()// 데이터 소스설정하는 함수사용
        
        
        
        collectionView.collectionViewLayout = compositianlLayout//컬렉션 뷰의 레이아웃설정
        
        viewModel.process(action: .loadData)//데이터 로드작업
        viewModel.process(action: .loadCoupon)
    }
    
    private  func setCompositinalLayout() -> UICollectionViewCompositionalLayout { // 각세션별 레이아웃을 설정하는 함수
        UICollectionViewCompositionalLayout{[weak self] section, _ in
            switch self?.currentSection[section]{
            case .banner:
                return HomeBannerCollectionViewCell.bannerLayout()// 배너 섹션의 레이아웃을 반환하는것
            case .horizontalProductItem:
                return  HomeProductCollectionViewCell.horizontalProductItemLayout()
            case .couponButton:
                return HomeCouponButtonCollectionViewCell.couponButtonItemLayout()
                
            case .verticalProductItem:
                return  HomeProductCollectionViewCell.verticalProductItemLayout()
                
            case .none: return nil
            }
        }
    }
    private func bindingViewModel() {
        viewModel.state.$collectionViewModels.receive(on: DispatchQueue.main)
            .sink{ [weak self] _ in
                self?.applySnapShot()
                
            }.store(in: &cancellables)
    }
    
    
    private func setDataSource() -> DataSource {
       return UICollectionViewDiffableDataSource(collectionView: collectionView,cellProvider: { [weak self] collectionView, indexPath, viewModel in
            
           switch self?.currentSection[indexPath.section] {
            case .banner :
                return self?.bannerCell(collectionView,indexPath,viewModel)
                
            case .horizontalProductItem, .verticalProductItem:
                return self?.ProductItemCell(collectionView,indexPath,viewModel)
            case .couponButton:
                return self?.couponButtonCell(collectionView,indexPath,viewModel)
            case .none :
                return .init()
            }
            
            
        })
    }
    
    private func applySnapShot() {
        var snapShot : Snapshot = Snapshot()
        if let bannerViewModels = viewModel.state.collectionViewModels.bannerViewModels{
            snapShot.appendSections([.banner])
            snapShot.appendItems(bannerViewModels ,toSection: .banner)
        }
        if let horizontalViewModels = viewModel.state.collectionViewModels.horizontalProductViewModels{
            snapShot.appendSections([.horizontalProductItem])
            snapShot.appendItems(horizontalViewModels, toSection: .horizontalProductItem)
        }
        if let couponViewModels = viewModel.state.collectionViewModels.couponState{
            snapShot.appendSections([.couponButton])
            snapShot.appendItems(couponViewModels,toSection: .couponButton)
        }
        
        if let verticalViewModels = viewModel.state.collectionViewModels.verticalProductViewModels{
            
            snapShot.appendSections([.verticalProductItem])
            snapShot.appendItems(verticalViewModels, toSection: .verticalProductItem)
        }
        dataSource.apply(snapShot)
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
    
    private func couponButtonCell(_ collectionView: UICollectionView,_ indexPath: IndexPath,_ viewModel:AnyHashable) -> UICollectionViewCell{
        
        guard let viewModel = viewModel as? HomeCouponButtonCollectionViewCellViewModel,
              
                let cell : HomeCouponButtonCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCouponButtonCollectionViewCell", for : indexPath) as?
                HomeCouponButtonCollectionViewCell else {return .init()}
        cell.setViewModel(viewModel)
        return cell
    }
}
#Preview {
    UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() as!
    HomeViewController
}
