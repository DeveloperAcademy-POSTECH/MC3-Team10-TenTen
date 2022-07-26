//
//  Words.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/20.
//

import Foundation
import RealmSwift


class Words: RealmModel {
    @Persisted
    var content: String
}
