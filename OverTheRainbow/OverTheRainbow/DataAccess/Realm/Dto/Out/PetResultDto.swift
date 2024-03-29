//
//  PetResultDto.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/20.
//

import Foundation

struct PetResultDto {
    private(set) var id: String
    private(set) var name: String
    private(set) var species: String
    private(set) var imgUrl: URL?
    private(set) var birth: Date
    private(set) var age: Int
    private(set) var weight: Double
    
    public static func of(pet: Pet) -> PetResultDto {
        return PetResultDto(
            id: pet.id,
            name: pet.name,
            species: pet.species,
            imgUrl: pet.imgUrl,
            birth: pet.birth,
            age: pet.age,
            weight: pet.weight
        )
    }
}
