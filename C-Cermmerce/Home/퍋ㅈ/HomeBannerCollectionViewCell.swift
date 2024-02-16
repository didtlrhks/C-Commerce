//
//  HomeBannerCollectionViewCell.swift
//  C-Cermmerce
//
//  Created by 양시관 on 2/12/24.
//

import UIKit


struct HomeBannerCollectionViewCellViewModel : Hashable {
    let bannerImage : UIImage
}

class HomeBannerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setViewModel(_ viewModel: HomeBannerCollectionViewCellViewModel){
        imageView.image = viewModel.bannerImage
    }
}
