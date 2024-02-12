//
//  HomeBannerCollectionViewCell.swift
//  C-Cermmerce
//
//  Created by 양시관 on 2/12/24.
//

import UIKit

class HomeBannerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setImage(_ image: UIImage){
        imageView.image = image
    }
}
