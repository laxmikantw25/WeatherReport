//
//  DateTimeUtil.swift
//  WeatherState
//
//  Created by SDB01 on 29/12/19.
//

import Foundation

public class DateTimeUtil{
    
    static let DATE_FORMAT = "yyyy'-'MM'-'dd HH:mm:ss"
    
    static let  DATE_ONLY_FORMAT = "yyyy'-'MM'-'dd"
    
    static let  TIME_ONLY_FORMAT = "HH:mm:ss"

    static func UTCToLocal(date: String?, format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DATE_FORMAT
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date!)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format
        
        let dt1 = dateFormatter.string(from: dt!)
        return dt1
    }

    static func UTCtoTimeLocal(date: String?, format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DATE_FORMAT
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date!)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format
        
        let dt1 = dateFormatter.string(from: dt!)
        return dt1
    }
}
