//
//  LetterResultDto.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/21.
//

import Foundation

struct LetterResultDto {
    private(set) var id: String
    private(set) var title: String
    private(set) var imgUrl: String?
    private(set) var date: String
    private(set) var createdAt: Date
    private(set) var updatedAt: Date
    private(set) var status: LetterStatus
    
    public static func of(_ letter: Letter) -> LetterResultDto {
        return LetterResultDto(id: letter.id, title: letter.title, imgUrl: letter.imgUrl, date: letter.date, createdAt: letter.createdAt, updatedAt: letter.updatedAt, status: letter.status)
    }
}
