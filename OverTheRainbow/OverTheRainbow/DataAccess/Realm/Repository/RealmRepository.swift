//
//  RealmRepository.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/20.
//

import Foundation
import RealmSwift

class RealmRepository {
    private let realm: Realm
    
    func save<T: RealmModel>(_ object: T) {
        realm.add(object)
    }
    
    func update<T: Object>(_ object: T) {
        realm.add(object, update: .modified)
    }
    
    func findAll<T: Object>() -> Results<T> {
        return realm.objects(T.self)
    }
    
    func findById<T: Object>(id: ObjectId) -> T? {
        guard let result = realm.object(ofType: T.self, forPrimaryKey: id) else {
            return nil
        }
        return result
    }
    
    func findRandomOne<T: Object>() -> T? {
        return realm.objects(T.self).getRandomFirst()
    }
    
    init(realm: Realm) {
        self.realm = realm;
    }
}
