//
//  Font.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import UIKit
extension UIFont {
    static func normalFont() -> UIFont{
        return UIFont.systemFont(ofSize: 18)
    }
    
    static func bigFont() -> UIFont{
        return UIFont.systemFont(ofSize: 24)
    }
    
    static func bigBoldFont() -> UIFont{
        return UIFont.boldSystemFont(ofSize: 24)
    }
}
