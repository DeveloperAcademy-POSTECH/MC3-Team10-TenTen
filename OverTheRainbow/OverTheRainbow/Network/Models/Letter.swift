//
//  Letter.swift
//  OverTheRainbow
//
//  Created by Jihye Hong on 2022/07/23.
//

import Foundation

struct Letter: Codable {
    var title: String?
    var date: String
}

// FIXME: - 더미로 넣은 Letter 데이터
var tempLetters: [Letter] = [
    Letter(title: "c5 15번 사물함\n비밀번호: 4860\n열어보세용~", date: "오늘"),
    Letter(title: "c5 15번 사물함\n비밀번호: 4860\n열어보세용~", date: "22.06.03"),
]
