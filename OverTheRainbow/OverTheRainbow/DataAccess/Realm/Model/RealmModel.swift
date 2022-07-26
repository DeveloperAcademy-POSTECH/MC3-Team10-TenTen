//
//  RealmModel.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/20.
//
// swiftlint:disable identifier_name

import Foundation
import RealmSwift

class RealmModel: Object {
    @Persisted(primaryKey: true)
    var _id: ObjectId
    
    var id: String { get { _id.stringValue } }
}
