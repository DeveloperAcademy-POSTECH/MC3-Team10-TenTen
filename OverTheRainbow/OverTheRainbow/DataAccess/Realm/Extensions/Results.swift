//
//  File.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/22.
//

import Foundation
import RealmSwift

extension Results where Element: Object {
    func toArray() -> Array<Element> {
        return Array(self)
    }
    
    // TODO: type narrowing 추가
    func getRandomFirst() -> Element? {
        return self.sorted { curr, next in
            if Int.random(in: 1...10) < 5 { return true }
            else { return false }
        }.first
    }
}
