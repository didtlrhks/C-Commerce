//
//  SplashViewController.swift
//  C-Cermmerce
//
//  Created by 양시관 on 2/11/24.
//

import UIKit

class SplashViewController: UIViewController {
    @IBOutlet var appIconCenterYConstraint: NSLayoutConstraint!
    
    @IBOutlet var appIconCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet var appIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        appIconCenterXConstraint.constant = -(view.frame.width / 2) - (appIcon.frame.width / 2)
        appIconCenterYConstraint.constant = -(view.frame.height / 2) - (appIcon.frame.height / 2)
        
        UIView.animate(withDuration: 2) {//후인 클로저 생략한는거 사용ㅎㅎㅎ
            [weak self] in
            self?.view.layoutIfNeeded()
        }
        
    }
    
}
