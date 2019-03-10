//
//  MapUseCase.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation

class MapUseCase {
    private let mapRep = MapRepository()
    func getNearPeople(latitude : Double , longitude : Double , completion : @escaping ([PeopleLocation]) -> ()) {
        
        mapRep.getNearPeople(completion: completion)
        
    }
    
}
