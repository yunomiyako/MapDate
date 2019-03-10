//
//  MapUseCase.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation

class MapUseCase {
    
    func getNearPeople(latitude : Double , longitude : Double) -> [PeopleLocation] {
        let dummydata = """
            [
            {
                "id" : "123" ,
                "longtitude" : -120 ,
                "latitude" : 37.78
            } ,
            {
                "id" : "124" ,
                "longtitude" : -121 ,
                "latitude" : 37
            }]
            """.data(using: .utf8)!
        
        let users = try? JSONDecoder().decode([PeopleLocation].self, from: dummydata)
        return users ?? []
    }
    
}
