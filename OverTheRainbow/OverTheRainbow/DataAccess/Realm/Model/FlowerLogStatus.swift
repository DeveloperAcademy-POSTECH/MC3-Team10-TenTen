//
//  FlowerLogStatus.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/21.
//

import Foundation
import RealmSwift

enum FlowerLogStatus: String, PersistableEnum {
    case sent = "SENT"
    case unsent = "UNSENT"
}
