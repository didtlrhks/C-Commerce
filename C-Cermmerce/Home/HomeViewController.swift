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
        
       
        setDataSource()
        
        applySnapShot()
        
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
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,cellProvider: { collectionView, indexPath, viewModel in

            switch Section(rawValue: indexPath.section) {
            case .banner :
                guard let viewModel = viewModel as? HomeBannerCollectionViewCellViewModel,
                      let cell : HomeBannerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCollectionViewCell", for: indexPath) as? HomeBannerCollectionViewCell else {return .init() }
               
                cell.setViewModel(viewModel)
                return cell
                
            case .horizontalProductItem, .verticalProductItem:
               guard let viewModel = viewModel as? HomeProductCollectionViewCellViewModel,

                        let cell : HomeProductCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeProductCollectionViewCell", for : indexPath) as?
                        HomeProductCollectionViewCell else {return .init()}
                cell.setViewModel(viewModel)
                return cell
            case .none :
                return .init()
            }
            
           
        })
    }
    
    private func applySnapShot() {
        var snapShot : NSDiffableDataSourceSnapshot<Section,AnyHashable> = NSDiffableDataSourceSnapshot<Section,AnyHashable>()
        snapShot.appendSections([.banner])
        snapShot.appendItems([
            HomeBannerCollectionViewCellViewModel(bannerImage: UIImage(resource: .slide1)),
            HomeBannerCollectionViewCellViewModel(bannerImage: UIImage(resource: .slide2)),
            HomeBannerCollectionViewCellViewModel(bannerImage: UIImage(resource: .slide3))]
                             ,toSection: .banner)
        
        snapShot.appendSections([.horizontalProductItem])
        snapShot.appendItems(
            [HomeProductCollectionViewCellViewModel(imageUrlString: "", title: "playstation1", reasonDiscountString: "쿠폰 할인", originalPrice: "200000", discountPrice: "80000"),
                              HomeProductCollectionViewCellViewModel(imageUrlString: "", title: "playstation2", reasonDiscountString: "쿠폰 할인", originalPrice: "300000", discountPrice: "180000"),HomeProductCollectionViewCellViewModel(imageUrlString: "", title: "playstation3", reasonDiscountString: "쿠폰 할인", originalPrice: "400000", discountPrice: "280000"),
                              HomeProductCollectionViewCellViewModel(imageUrlString: "", title: "playstation3", reasonDiscountString: "쿠폰 할인", originalPrice: "500000", discountPrice: "380000"),
                              HomeProductCollectionViewCellViewModel(imageUrlString: "", title: "playstation4", reasonDiscountString: "쿠폰 할인", originalPrice: "600000", discountPrice: "480000"),HomeProductCollectionViewCellViewModel(imageUrlString: "", title: "playstation6", reasonDiscountString: "쿠폰 할인", originalPrice: "700000", discountPrice: "580000")], toSection: .horizontalProductItem)
        
        
        snapShot.appendSections([.verticalProductItem])
        snapShot.appendItems(
            [HomeProductCollectionViewCellViewModel(imageUrlString: "", title: "playstation5", reasonDiscountString: "쿠폰 할인", originalPrice: "200000", discountPrice: "80000"),
                              HomeProductCollectionViewCellViewModel(imageUrlString: "", title: "playstation6", reasonDiscountString: "쿠폰 할인", originalPrice: "300000", discountPrice: "180000"),HomeProductCollectionViewCellViewModel(imageUrlString: "", title: "playstation7", reasonDiscountString: "쿠폰 할인", originalPrice: "400000", discountPrice: "280000"),
                              HomeProductCollectionViewCellViewModel(imageUrlString: "", title: "playstation8", reasonDiscountString: "쿠폰 할인", originalPrice: "500000", discountPrice: "380000"),
                              HomeProductCollectionViewCellViewModel(imageUrlString: "", title: "playstation9", reasonDiscountString: "쿠폰 할인", originalPrice: "600000", discountPrice: "480000"),HomeProductCollectionViewCellViewModel(imageUrlString: "", title: "playstation10", reasonDiscountString: "쿠폰 할인", originalPrice: "700000", discountPrice: "580000")], toSection: .verticalProductItem)
        
        dataSource?.apply(snapShot)
    }


}

#Preview {
    UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() as!
    HomeViewController
}
