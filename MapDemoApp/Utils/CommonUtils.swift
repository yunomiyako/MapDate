//
//  CommonUtils.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
func LogDebug(_ message: String,
              function: String = #function,
              file: String = #file,
              line: Int = #line) {
    #if DEBUG
    let cells = file.components(separatedBy: "/")
    let fileName = cells[cells.count-1]
    print("DEBUG: \(message)")
    #elseif DEBUG_STAGING
    print("DEBUG: \(message)")
    #else
    #endif
}

func dispatch_after(_ delay_time:Double, block: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay_time, execute:block)
}

func getTimeStamp() {
    
}

func convertTimeStampToDate(timestamp : Double) -> Date{
    return Date(timeIntervalSince1970: TimeInterval(exactly: timestamp) ?? 0)
}
