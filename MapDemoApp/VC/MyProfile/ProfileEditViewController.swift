//
//  ProfileEditViewController.swift
//  MapDemoApp
//
//  Created by 萬年　司 on 2019/03/11.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import UIKit
import TinyConstraints

final class EditProfileViewController: UIViewController {
    
    let textEditer = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray
        textEditer.center = self.view.center
        textEditer.backgroundColor = UIColor.white
        view.addSubview(textEditer)
        textEditer.edgesToSuperview(insets: TinyEdgeInsets(top: 100, left: 20, bottom: 30, right: 10))
        
    }
    
    
}
