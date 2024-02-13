//
//  HomeProductCollectionViewCell.swift
//  C-Cermmerce
//
//  Created by 양시관 on 2/13/24.
//

import UIKit


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
        productTitleLabel.text = viewModel.title
        productReasonDiscountLabel.text = viewModel.reasonDiscountString
        originalPriceLabel.attributedText = NSAttributedString(string: viewModel.originalPrice, attributes: [NSAttributedString.Key.strikethroughStyle:NSUnderlineStyle.single.rawValue]) 
        discountPriceLabel.text = viewModel.discountPrice
    }
}
