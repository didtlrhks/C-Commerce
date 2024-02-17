//
//  HomeProductCollectionViewCell.swift
//  C-Cermmerce
//
//  Created by 양시관 on 2/13/24.
//

import UIKit
import Kingfisher


struct HomeProductCollectionViewCellViewModel : Hashable{
    let imageUrlString : String
    let title : String
    let reasonDiscountString: String
    let originalPrice : String
    let discountPrice : String
}


class HomeProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var productItemImageView: UIImageView!{
        didSet {
            productItemImageView.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet var productTitleLabel: UILabel!
    @IBOutlet var productReasonDiscountLabel: UILabel!
    @IBOutlet var originalPriceLabel: UILabel!
    
    @IBOutlet var discountPriceLabel: UILabel!
    
    
    
    func setViewModel(_ viewModel: HomeProductCollectionViewCellViewModel) {
        productItemImageView.kf.setImage(with: URL(string: viewModel.imageUrlString))
        productTitleLabel.text = viewModel.title
        productReasonDiscountLabel.text = viewModel.reasonDiscountString
        originalPriceLabel.attributedText = NSAttributedString(string: viewModel.originalPrice, attributes: [NSAttributedString.Key.strikethroughStyle:NSUnderlineStyle.single.rawValue]) 
        discountPriceLabel.text = viewModel.discountPrice
    }
}

extension HomeProductCollectionViewCell {
    static func horizontalProductItemLayout() -> NSCollectionLayoutSection {
        let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item : NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize : NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .absolute(117), heightDimension: .estimated(224))
        
        let group : NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section : NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top:20,leading: 33,bottom: 0,trailing: 33)
        
        return section
    }
    
    static func verticalProductItemLayout() -> NSCollectionLayoutSection {
        let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .estimated(277))
        let item : NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize : NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(277))
        
        let group : NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section : NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        
        section.contentInsets = .init(top:20,leading: 19   ,bottom: 0,trailing: 19)
        
        return section
    }
}
