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
    private let matchUseCase = MatchUseCase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    private func presentMapViewController() {
        let prevState = matchUseCase.getSyncMatchState()
        let matchModel = MatchModel(state : prevState)
        if let vc = MapViewController(matchModel: matchModel) {
            self.present(vc, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        firebaseUseCase.checkSignIn(
            whenSignIn: {user in
                //ログイン済み
                self.presentMapViewController()
        },
            whenNot: {
                //ログインしていないのでLoginViewControllerを表示
                let vc = LoginViewController()
                self.present(vc, animated: true)
        }
        )
    }
}

