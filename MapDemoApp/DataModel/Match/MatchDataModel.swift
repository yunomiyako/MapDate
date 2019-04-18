//
//  MatchDataModel.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/04/11.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
class MatchDataModel {
    var transaction_id : String
    var your_location_id : String
    var partner_location_id : String
    
    init(transaction_id : String , your_location_id : String , partner_location_id : String) {
        self.transaction_id = transaction_id
        self.your_location_id = your_location_id
        self.partner_location_id = partner_location_id
    }
}
