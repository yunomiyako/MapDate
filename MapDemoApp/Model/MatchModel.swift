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
    func whenStateWillChange(newValue : MatchState , value : MatchState)
    func whenStateDidChange(oldValue : MatchState , value : MatchState)
}

class MatchModel {
    weak var delegate :MatchModelDelegate? = nil
    private let matchUseCase = MatchUseCase()
    
    var discoveryRadius : Double = 3000
    var discoveryCenter : CLLocationCoordinate2D? = nil
    var didConfirmShareLocation = false
    
    var stateToBottom : [MatchState : UIView]  = [:]
    var state : MatchState = .initial  {
        willSet {
            self.delegate?.whenStateWillChange(newValue: newValue, value: state)
        }
        didSet {
            self.matchUseCase.setSyncMatchState(state: state)
            self.delegate?.whenStateDidChange(oldValue: oldValue, value: state)
        }
    }
    
    var matchData : MatchDataModel? = nil
    
    init(state : MatchState) {
        self.state = state
    }
    
    func loadMatchData() {
        //SQLを探してマッチを探してみる
        self.matchUseCase.restoreMatch(completion: { res in
            if res.result == "success" {
                self.matching(transaction_id: res.transaction_id, your_location_id: res.your_location_id, partner_location_id: res.partner_location_id)
            } else {
                //ratingかどうかを取得
                
            }
        })
        
    }
    
    func matching(transaction_id: String?, your_location_id: String?, partner_location_id: String?) {
        if let t = transaction_id , let y = your_location_id , let p = partner_location_id {
            self.matchData = MatchDataModel(transaction_id: t, your_location_id: y, partner_location_id: p)
            self.state = .matched
        }
    }
    
    func clearMatch() {
        self.matchData = nil
    }
}
