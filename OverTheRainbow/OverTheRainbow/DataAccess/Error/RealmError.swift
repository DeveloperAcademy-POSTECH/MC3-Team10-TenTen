//
//  RealmError.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/20.
//

import Foundation

enum RealmError: String, Error {
    case petNotFound = "펫이 존재하지 않음"
    case letterNotFound = "편지가 존재하지 않음"
    case flowerNotFound = "꽃이 존재하지 않음"
    case illegalDateArgument = "올바르지 않은 Date 입력"
    case wordNotFound = "DB에 격려의 말이 없음"
}
