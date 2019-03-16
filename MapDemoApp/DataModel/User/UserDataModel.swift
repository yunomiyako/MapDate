//
//  UserDataModel.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/16.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation

class UserDataModel {
    var uid : String?
    var displayName : String?
    var photo_url : String? = nil
    var email : String? = nil
    
    init(uid : String? , displayName : String?) {
        self.uid = uid
        self.displayName = displayName
    }
}
