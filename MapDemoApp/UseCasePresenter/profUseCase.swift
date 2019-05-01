//
//  profUseCase.swift
//  MapDemoApp
//
//  Created by 萬年司 on 2019/04/25.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation

class ProfUseCase {

    private let profRep = ProfRepository()
    private let firebaseUseCase = FirebaseUseCase()
    
    func getData(completion : @escaping (RequestProfGetResponse) -> ()){
        let user = firebaseUseCase.getCurrentUser()
        guard let uid = user.uid else {return}
        profRep.requestGetProf(uid: uid, completion: completion)
    }
    
    func postData(name:String,age:String,job:String,intro:String,is_man:Bool,
                  is_woman:Bool,completion : @escaping (RequestProfPostResponse) -> ()){
        let user = firebaseUseCase.getCurrentUser()
        guard let uid = user.uid else {return}
        profRep.requestPostProf(uid: uid,name: name, age: age, job: job,intro:intro,is_man:is_man,is_woman:is_woman,completion: completion)
    }

}

struct profData:Codable {
    
    var uid:String
    var name:String
    var age: String
    var job:String
    var intro:String
    var is_man:Bool
    var is_woman:Bool
    
}
