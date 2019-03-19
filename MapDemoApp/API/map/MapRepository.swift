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
    
    //singleton
    let apiCliant = APIClient.shared
    
    //近くにいる人数を取得する
    func getNearPeopleNumber(completion : @escaping (GetNearPeopleNumberResponse) -> ()) {
        let request = GetNearPeopleNumberRequest()
        apiCliant.call(request: request,
                       success:  completion,
                       failure: {
                        LogDebug("getNearPeopleNumber failed")
        })
    }


}
