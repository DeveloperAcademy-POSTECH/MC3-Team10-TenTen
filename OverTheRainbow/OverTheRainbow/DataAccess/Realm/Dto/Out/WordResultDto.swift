//
//  WordResultDto.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/23.
//

import Foundation

struct WordResultDto {
    private(set) var content: String
    
    public static func of(_ word: Words) -> WordResultDto {
        return WordResultDto(content: word.content)
    }
}
