//
//  ViewController.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//aaaa

import UIKit
class HomeViewController: UIViewController {
    private let firebaseUseCase = FirebaseUseCase()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {

        LogDebug("HomeViewControlle appear")
        firebaseUseCase.checkSignIn(
            whenSignIn: {user in
                //ログイン済み
                //let vc = ChatViewController()
                let vc = MyProfileViewController()
                //let vc = MapViewController()
                self.present(vc, animated: true)
            },
            whenNot: {
                //ログインしていないのでLoginViewControllerを表示
                //let vc = LoginViewController()
                let vc = MyProfileViewController()
                self.present(vc, animated: true)
            }
        )
        
    }
}

