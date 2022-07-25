//
//  FlowerResultDto.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/21.
//

import Foundation

struct FlowerResultDto {
    private(set) var id: String
    private(set) var name: String
    private(set) var meaning: String
    private(set) var imgUrl: String
    
    public static func of(_ flower: Flower) -> FlowerResultDto {
        return FlowerResultDto(id: flower.id, name: flower.name, meaning: flower.meaning, imgUrl: flower.imgUrl)
    }
}
