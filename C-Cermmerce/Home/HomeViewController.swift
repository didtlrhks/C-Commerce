//
//  HomeViewController.swift
//  C-Cermmerce
//
//  Created by 양시관 on 2/12/24.
//

import UIKit

class HomeViewController:UIViewController {
    
    enum Section {
        case banner
    }
    
    
    @IBOutlet var collectionView: UICollectionView!
    private var dataSource : UICollectionViewDiffableDataSource<Section, AnyHashable>?
//    private var compositianlLayout : UICollectionViewCompositionalLayout = {
//        
//    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = UICollectionViewCell()
            return cell
        })

       
    }
    


}
