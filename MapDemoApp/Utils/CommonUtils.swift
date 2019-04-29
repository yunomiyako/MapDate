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

func LogDebugTimer(_ message: String,
              function: String = #function,
              file: String = #file,
              line: Int = #line) {
    #if DEBUG
    let cells = file.components(separatedBy: "/")
    let fileName = cells[cells.count-1]
    print("TIMER: \(message)")
    #elseif DEBUG_STAGING
    print("TIMER: \(message)")
    #else
    #endif
}


func dispatch_after(_ delay_time:Double, block: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay_time, execute:block)
}

func dispatch_async_main(_ block: @escaping () -> ()) {
    DispatchQueue.main.async(execute: block)
}



class CommonUtils {
    static func runEveryNSeconds(n : Int) -> Bool{
        let date = Date()
        let second = Int(date.timeIntervalSince1970)
        if second % n == 0 { return true }
        else { return false }
    }
    
    static func convertDateToTimeStamp(date : Date) -> Double {
        return date.timeIntervalSince1970
    }
    
    static func convertTimeStampToDate(timestamp : Double) -> Date{
        return Date(timeIntervalSince1970: TimeInterval(exactly: timestamp) ?? 0)
    }
    
    class func stringFromDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        if let c = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian) as Calendar? {
            formatter.calendar = c
        }
        formatter.locale = NSLocale.system
        formatter.timeZone = NSTimeZone.system
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    /**
     今日の履歴ならHH:MM, 昨日以降ならyyyy-MM-ddを返す
     */
    class func createHistroyDateString(target: Date) -> String {
        let now = Date()
        let nowDayText = CommonUtils.stringFromDate(date: now, format: "yyyy-MM-dd")
        let resultDayText = CommonUtils.stringFromDate(date: target, format: "yyyy-MM-dd")
        let resultHourText = CommonUtils.stringFromDate(date: target, format: "HH:mm")
        let text:String
        
        if nowDayText == resultDayText {
            text = resultHourText
        } else {
            text = resultDayText
        }
        return text
    }
    

    /**
     名前の最初の1文字を取得
     */
    static func getNameFirstCharacter(_ name_user:String) -> String {
        var n = name_user
        if name_user.isEmpty {
            n = "No name"
        }
        return String(n.prefix(1))
    }
}
