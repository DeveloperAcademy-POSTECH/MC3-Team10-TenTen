//
//  Flower.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/20.
//

import Foundation
import RealmSwift

class Flower: RealmModel {
    @Persisted
    var name: String
    
    @Persisted
    var meaning: String
    
    @Persisted
    var imgUrl: String
}
