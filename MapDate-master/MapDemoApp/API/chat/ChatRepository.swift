//
//  fetchMessage.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import Alamofire

class ChatRepository {
    
    //メッセージの取得
    func fetchMessages(completion : @escaping ([ChatMessage]) -> ()) {
        let url = "http://localhost:3000/chat_message"
        Alamofire.request(url).responseJSON { response in
            if let data = response.data {
                LogDebug(data.description)
                let messages = try? JSONDecoder().decode([ChatMessageViewModel].self, from: data)
                guard let m_list = messages else {return}
                LogDebug(m_list.debugDescription)
                let m : [ChatMessage] = m_list.map{ vm in ChatMessage(vm : vm) }
                LogDebug(m.debugDescription)
                completion(m)
            } else {
                
            }
        }
    }
}
