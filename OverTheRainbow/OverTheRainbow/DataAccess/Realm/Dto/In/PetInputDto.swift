//
//  AddPetInDto.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/20.
//

import Foundation

struct PetInputDto {
    private(set) var name: String
    private(set) var species: String
    private(set) var birth: Date
    private(set) var weight: Double
    private(set) var imgUrl: String?
    
    func toPet() -> Pet {
        return Pet(self.name, self.species, imgUrl: self.imgUrl, birth: self.birth, weight: self.weight)
    }
    
    
    init(_ name: String, _ species: String, _ birth: Date, _ weight: Double, imgUrl: String) {
        self.name = name
        self.species = species
        self.birth = birth
        self.weight = weight
        self.imgUrl = imgUrl
    }
    
    init(_ name: String, _ species: String, _ birth: Date, _ weight: Double) {
        self.name = name
        self.species = species
        self.birth = birth
        self.weight = weight
    }
}
