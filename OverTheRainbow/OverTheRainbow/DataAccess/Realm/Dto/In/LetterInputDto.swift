//
//  LetterInputDto.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/20.
//

import Foundation

struct LetterInputDto {
    let petId: String
    let letter: LetterInput
    
    func toLetter() -> Letter {
        return letter.toLetter()
    }
}

struct LetterInput {
    let title: String
    let content: String
    let imgUrl: String?
    
    func toLetter() -> Letter {
        return Letter(title, content, imgUrl)
    }
}
