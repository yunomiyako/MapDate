//
//  LoginViewController.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/16.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI


class LoginViewController: UIViewController , FUIAuthDelegate {

    var authUI: FUIAuth { get { return FUIAuth.defaultAuthUI()!}}
    // 認証に使用するプロバイダの選択
    let providers: [FUIAuthProvider] = [
        FUIGoogleAuth(),
        FUIPhoneAuth(authUI:FUIAuth.defaultAuthUI()!),
        ] 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // authUIのデリゲート
        self.authUI.delegate = self
        self.authUI.providers = providers
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.startAuthentificate()
    }
        
    func startAuthentificate() {
        let authViewController = self.authUI.authViewController()
        self.present(authViewController, animated: true, completion: nil)
    }
    
    //　認証画面から離れたときに呼ばれる（キャンセルボタン押下含む）
    public func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?){
        if error == nil {
            LogDebug("認証に成功しました")
            self.dismiss(animated: true, completion: nil)
        }
        // エラー時の処理をここに書く
    }
}
