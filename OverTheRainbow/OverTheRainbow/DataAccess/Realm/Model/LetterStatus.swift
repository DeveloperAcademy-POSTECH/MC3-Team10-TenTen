//
//  LetterStatus.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/20.
//

import Foundation
import RealmSwift

enum LetterStatus: String, PersistableEnum {
    case sent = "SENT"
    case saved = "SAVED"
    case temporary = "TEMPORARY"
}
