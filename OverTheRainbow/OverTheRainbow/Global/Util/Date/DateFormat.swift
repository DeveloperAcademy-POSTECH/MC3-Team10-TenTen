//
//  DateFormat.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/21.
//

import Foundation

enum DateFormat {
    case yearMonthDate
    case yearMonth
    case yearMonthKr
    
    var value: String {
        get {
            switch (self) {
            case .yearMonth:
                return "yyyy.MM"
            case .yearMonthDate:
                return "yyyy.MM.dd"
            case .yearMonthKr:
                return "yyyy년 MM월"
            }
        }
    }
}
