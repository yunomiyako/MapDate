//
//  UserDefaultsUseCase.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/16.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
/**
 * NSUserDefaultsを用いる実装を管理
 */
class UserDefaultsRepository {
    
    //シングルトン
    static let sharedInstance = UserDefaultsRepository()
    private init() {
    }
    
    /*
     - parameter content:保存するコンテンツ, forKey: どこへ保存するかのpath
     */
    final func set (_ content:Any, forKey:String) {
        LogDebug("\(forKey) set")
        UserDefaults.standard.set(content, forKey: forKey)
    }
    
    final func get(forKey:String) -> Any? {
        LogDebug("\(forKey) got")
        return UserDefaults.standard.object(forKey:forKey)
    }
    
    final func clear(forKey:String) {
        UserDefaults.standard.removeObject(forKey: forKey)
    }
    
}
