//
//  MapState.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/11.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation

enum MapState {
    case initial //通常モード
    case finding //探し中
    case chatting //話し中
    case meetUp //待ち合わせ
    case meeting //during meeting
    case farewell //別れ
}
