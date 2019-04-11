//
//  MatchModel.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/04/11.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import UIKit
import MapKit
protocol MatchModelDelegate : class {
    func whenStateWillChange(newValue : MapState , value : MapState)
    func whenStateDidChange(oldValue : MapState , value : MapState)
}

class MatchModel {
    weak var delegate :MatchModelDelegate? = nil
    
    var discoveryRadius : Double = 3000
    var discoveryCenter : CLLocationCoordinate2D? = nil
    var didConfirmShareLocation = false
    
    var stateToBottom : [MapState : UIView]  = [:]
    var state : MapState = .initial  {
        willSet {
            self.delegate?.whenStateWillChange(newValue: newValue, value: state)
        }
        didSet {
            self.delegate?.whenStateDidChange(oldValue: oldValue, value: state)
        }
    }
    
    var matchData : MatchDataModel? = nil
    
    
    func matching(transaction_id: String?, your_location_id: String?, partner_location_id: String?) {
        if let t = transaction_id , let y = your_location_id , let p = partner_location_id {
            self.matchData = MatchDataModel(transaction_id: t, your_location_id: y, partner_location_id: p)
        }
    }
    
    func clearMatch() {
        self.matchData = nil
    }
}
