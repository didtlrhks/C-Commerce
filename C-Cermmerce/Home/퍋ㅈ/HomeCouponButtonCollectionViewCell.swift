//
//  HomeCouponButtonCollectionViewCell.swift
//  C-Cermmerce
//
//  Created by 양시관 on 2/18/24.
//

import UIKit

struct HomeCouponButtonCollectionViewCellViewModel : Hashable {
    
    enum CouponState {
        case enable
        case disable
    }
    var state : CouponState
}

final class HomeCouponButtonCollectionViewCell: UICollectionViewCell {
    
   
    @IBOutlet var couponButton: UIButton! {
        didSet {
            couponButton.setImage(CPImage.buttonActivate, for: .normal)
            couponButton.setImage(CPImage.buttonComplete, for: .disabled)
        }
    }
    
    func setViewModel(_ viewModel: HomeCouponButtonCollectionViewCellViewModel)
    
    {
        
        couponButton.isEnabled = switch viewModel.state{
        case .enable:
            true
        case .disable:
            false
        }
    }
}
