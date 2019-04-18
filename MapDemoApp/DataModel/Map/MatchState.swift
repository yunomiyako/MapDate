//
//  MatchState.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/11.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation

enum MatchState {
    case initial //通常モード
    case matched //マッチしたあと
    case rating //rate中
    
    func str() -> String {
        switch self {
        case .initial:
            return "initial"
        case .matched :
            return "matched"
        case .rating :
            return "rating"
        }
    }
    
    static func createStateFromStr(str : String) -> MatchState {
        if str == "initial" {
            return MatchState.initial
        } else if str == "matched" {
            return MatchState.matched
        } else if str == "rating" {
            return MatchState.rating
        }
        return MatchState.initial
    }
}
