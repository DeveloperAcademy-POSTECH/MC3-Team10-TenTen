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
}
