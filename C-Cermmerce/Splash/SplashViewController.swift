//
//  SplashViewController.swift
//  C-Cermmerce
//
//  Created by 양시관 on 2/11/24.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
   
    @IBOutlet var lottieAnimationView: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        lottieAnimationView.play {_ in
            
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let viewController = storyboard.instantiateInitialViewController()
            
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first(where: {$0.isKeyWindow }){
                window.rootViewController = viewController
            }
            
        }
       
    }
    
}
