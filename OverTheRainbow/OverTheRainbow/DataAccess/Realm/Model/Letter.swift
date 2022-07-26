//
//  Letter.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/20.
//

import Foundation
import RealmSwift

class Letter: RealmModel {
    @Persisted
    var title: String
    
    @Persisted(originProperty: "letters")
    var pet: LinkingObjects<Pet>
    
    @Persisted
    var content: String
    
    @Persisted
    var imgUrl: String?
    
    @Persisted
    var status: LetterStatus = .temporary
    
    @Persisted
    var createdAt: Date = Date.now
    
    @Persisted
    var updatedAt: Date = Date.now
    
    var date: String {
        get { return DateConverter.dateToString(self.createdAt) }
    }
    
    convenience init(_ title: String, _ content: String, _ imgUrl: String?) {
        self.init()
        self.title = title
        self.content = content
        self.imgUrl = imgUrl
    }
}
