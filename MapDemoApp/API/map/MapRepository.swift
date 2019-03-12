//
//  getNearPeople.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import Alamofire
class MapRepository {
    
    //近くにいる人の位置情報を取得する
    func getNearPeople(completion : @escaping ([PeopleLocation]) -> ()) {
        let url = "http://localhost:3000/people"
        Alamofire.request(url).responseJSON { response in
            if let data = response.data {
                let users = try? JSONDecoder().decode([PeopleLocation].self, from: data)
                guard let u = users else {return}
                completion(u)
            } else {
                
            }
        }
    }
    
    //近くにいる人数を取得する
    func getNearPeopleNumber(completion : @escaping (Int) -> ()) {
        let url = "http://localhost:3000/people_number"
        Alamofire.request(url).responseJSON { response in
            if let data = response.data {
                let number = try? JSONDecoder().decode(Int.self, from: data)
                guard let u = number else {return}
                completion(u)
            } else {
                
            }
        }
    }


}
