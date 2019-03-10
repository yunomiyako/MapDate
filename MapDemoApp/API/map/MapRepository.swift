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
            print(response)
            if let data = response.data {
                print(data)
                let users = try? JSONDecoder().decode([PeopleLocation].self, from: data)
                print(users)
                guard let u = users else {return}
                completion(u)
            } else {
                
            }
        }
    }

}
