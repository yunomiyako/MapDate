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
    func getNowUserLocation() -> LocationLog
    func foundRequestMatch(partner_location_ids : [String])
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
            LogDebugTimer(state.str())
            self.matchUseCase.setSyncMatchState(state: state)
            self.delegate?.whenStateDidChange(oldValue: oldValue, value: state)
        }
    }
    
    var matchData : MatchDataModel? = nil
    
    private var timer : Timer? = nil
    
    init(state : MatchState) {
        self.state = state
        self.matchUseCase.checkMatchState() { state in
            self.state = state
        }
        
        startConstantCheck()
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
    
    func quitRelationship() {
        guard let t = self.matchData?.transaction_id else {return}
        self.matchUseCase.matchAction(transaction_id:t, action: MatchActionType.quit) { state in
            self.state = state
        }
    }
    
    func meet() {
        guard let t = self.matchData?.transaction_id else {return}
        self.matchUseCase.matchAction(transaction_id: t, action: MatchActionType.meet) { state in
            //特にやることなし
        }
    }
    
    func findRequestMatch(completion : @escaping (FindRequestMatchResponse) -> () ) {
        guard let location = self.delegate?.getNowUserLocation() else {return}
        matchUseCase.findRequestMatch(location: location) {res in
            completion(res)
        }
    }
    
    func receiveMatch(partner_location_id : String) {
        self.matchUseCase.receiveMatch(partner_location_id: partner_location_id, completion: {res in
            self.matching(transaction_id: res.transaction_id, your_location_id: res.your_location_id, partner_location_id: res.partner_location_id)
        })
    }
    
    private func intialConstantCheck() {
        self.findRequestMatch(completion: {res in
            let ids = res.partner_location_ids
            if ids.count > 0 {
                self.delegate?.foundRequestMatch(partner_location_ids : ids)
            }
        })
    }
    
    private func matchedConstantCheck() {
        self.matchUseCase.checkMatchState(completion: {state in
            self.state = state
        })
    }
    
    private func constantCheck() {
        switch self.state {
        case .initial:
            self.intialConstantCheck()
        case .matched:
            self.matchedConstantCheck()
        case .rating:
            return
        }
    }
    
    //円をtimerでアニメートする
    private func startConstantCheck() {
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
        let timeInterval: TimeInterval = 5.0
        let timer  = Timer(timeInterval: timeInterval, repeats: true, block: {_ in
            self.constantCheck()
        })
        RunLoop.main.add(timer, forMode:RunLoop.Mode.common)
        self.timer = timer
    }
    
    func rateMatch(rate : Double) {
        guard let t = self.matchData?.transaction_id else {return}
        LogDebug("rateMatch started")
        self.matchUseCase.rateMatch(transaction_id: t, rate: rate) {_ in
            LogDebug("rateMatch finished")
            //別に何もしなくていい
        }
        self.state = .initial
    }
}
