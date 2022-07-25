//
//  NSObject+Extension.swift
//  OverTheRainbow
//
//  Created by Jihye Hong on 2022/07/24.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
