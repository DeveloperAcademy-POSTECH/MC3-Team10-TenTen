//
//  DateExtension.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/21.
//

import Foundation

extension Date {
    public static func getNextMonth(_ date: Date) -> Date? {
        guard let res = Calendar.current.date(byAdding: .month, value: 1, to: date) else {
            return nil
        }
        return res
    }
    
    public static func startOfToday(_ timeZone: String = "KST") -> Date {
        var calendar = Calendar.current
        if let timeZone = TimeZone(abbreviation: timeZone) {
            calendar.timeZone = timeZone
        }
        
        return calendar.startOfDay(for: Date.now)
    }
}
