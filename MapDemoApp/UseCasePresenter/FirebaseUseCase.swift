//
//  FirebaseUseCase.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/16.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import Firebase

class FirebaseUseCase {
    
    //signinしている時としていない時で処理を分ける
    func checkSignIn(whenSignIn : (UserDataModel) -> () , whenNot : () -> ()) {
        
    }
    
    //現在signinしているユーザの情報を取得する
    func getCurrentUser() -> UserDataModel{
        let user = Auth.auth().currentUser
        let userModel = UserDataModel(uid: user?.uid, displayName: user?.displayName)
        return userModel
    }
    
    //現在ログイン中のアカウントをsignOutする
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
}
