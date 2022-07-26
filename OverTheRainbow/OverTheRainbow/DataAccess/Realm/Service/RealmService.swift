//
//  RealmService.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/20.
//
// swiftlint:disable force_try

import Foundation
import RealmSwift

// TODO: Service 구현체 refactor
// TODO: updatedAt 구현
class RealmService: DataAccessService {
    private let realm: Realm
    private let repository: RealmRepository
    
    func addPet(_ inputDto: PetInputDto) {
        try! realm.write {
            let pet = inputDto.toPet()
            repository.save(pet)
        }
    }
    
    func findPet(id: String) throws -> PetResultDto {
        let objectId = stringToObjectId(id: id)
        
        // 찾는 pet이 없으면 error throw
        guard let pet: Pet = repository.findById(id: objectId) else {
            throw RealmError.petNotFound
        }
        
        return PetResultDto.of(pet: pet)
    }
    
    func findAllPet() -> Array<PetResultDto> {
        let results: Results<Pet> = repository.findAll()
            .sorted(byKeyPath: "createdAt", ascending: false)
        return results.toArray()
            .map { PetResultDto.of(pet: $0) }
    }
    
    func addLetter(_ inputDto: LetterInputDto) throws {
        let petId = stringToObjectId(id: inputDto.petId)
        guard let pet: Pet = repository.findById(id: petId) else {
            throw RealmError.petNotFound
        }
        let letter = inputDto.toLetter()
        
        try! realm.write {
            pet.letters.append(letter)
        }
    }
    
    func saveLetters(_ ids: String...) throws {
        try! ids.forEach { id in
            let letterId = stringToObjectId(id: id)
            guard let letter: Letter = repository.findById(id: letterId) else {
                throw RealmError.letterNotFound
            }
            
            try! realm.write {
                letter.status = .saved
            }
        }
    }
    
    func unsaveLetters(_ ids: String...) throws {
        try! ids.forEach { id in
            let letterId = stringToObjectId(id: id)
            guard let letter: Letter = repository.findById(id: letterId) else {
                throw RealmError.letterNotFound
            }
            
            try! realm.write {
                letter.status = .temporary
            }
        }
    }
    
    func send(_ id: String) throws {
        let petId = stringToObjectId(id: id)
        guard let pet: Pet = repository.findById(id: petId) else {
            throw RealmError.petNotFound
        }
        
        try! realm.write {
            pet.letters.where { $0.status != .sent }
                .forEach { $0.status = .sent }
            
            pet.flowerLogs.where { $0.status != .sent }
                .forEach { $0.status = .sent }
        }
    }
    
    func findUnsentLetters(_ id: String) throws -> Array<LetterResultDto> {
        let petId = stringToObjectId(id: id)
        guard let pet: Pet = repository.findById(id: petId) else {
            throw RealmError.petNotFound
        }
        
        return pet.letters
            .where { $0.status != .sent }
            .sorted(byKeyPath: "createdAt", ascending: false)
            .sorted {
                if $0.status == .saved  { return true }
                else if $1.status == .saved { return false }
                return true
            }
            .map { LetterResultDto.of($0) }
    }
    
    // TODO: sorted refactor
    func findSentLetters(_ id: String, _ selected: String) throws -> Array<LetterResultDto> {
        let petId = stringToObjectId(id: id)
        guard let pet: Pet = repository.findById(id: petId) else {
            throw RealmError.petNotFound
        }
        
        var selectedDate: Date
        do {
            selectedDate = try DateConverter.stringToDate(selected, .yearMonthKr)
        } catch {
            throw RealmError.illegalDateArgument
        }
        
        guard let next = Date.getNextMonth(selectedDate) else {
            throw RealmError.illegalDateArgument
        }
        return pet.letters
            .where { $0.status == .sent }
            .where { $0.createdAt >= selectedDate && $0.createdAt < next }
            .sorted(byKeyPath: "createdAt", ascending: false)
            .map { LetterResultDto.of($0) }
    }

    func findAllFlowers() -> Array<FlowerResultDto> {
        let results: Results<Flower> = repository.findAll()
        return results.toArray()
            .map { FlowerResultDto.of($0) }
    }
    
    func chooseFlower(petId: String, flowerId: String) throws {
        let petId = stringToObjectId(id: petId)
        guard let pet: Pet = repository.findById(id: petId) else {
            throw RealmError.petNotFound
        }
        let flowerId = stringToObjectId(id: flowerId)
        guard let flower: Flower = repository.findById(id: flowerId) else {
            throw RealmError.flowerNotFound
        }
        
        // 남아 있는 log가 있으면 있는 log를 바꾼다.
        let results: Results<FlowerLog> = repository.findAll().where { $0.status == .unsent }
        if !results.isEmpty {
            updateFlower(flower: flower, flowerLog: results[0])
        }
        
        // 남아 있는 log가 없으면 새 log 생성
        let flowerLog = FlowerLog(flower: flower)
        try! realm.write {
            pet.flowerLogs.append(flowerLog)
        }
    }
    
    func getMainView(_ id: String) throws -> MainViewResultDto {
        let petId = stringToObjectId(id: id)
        guard let pet: Pet = repository.findById(id: petId) else {
            throw RealmError.petNotFound
        }
        
        guard let word: Words = repository.findRandomOne() else {
            throw RealmError.wordNotFound
        }
        
        
        let flowerLog = pet.flowerLogs
            .where { $0.status == .unsent }
            .first
        let letterCount = pet.letters
            .where { $0.status != .sent }
            .count
        
        
        return MainViewResultDto(flowerLog, letterCount, word)
    }
    
    func getHeavenView(_ id: String) throws -> HeavenViewResultDto {
        let petId = stringToObjectId(id: id)
        guard let pet: Pet = repository.findById(id: petId) else {
            throw RealmError.petNotFound
        }
        
        let flowerLogs = pet.flowerLogs
            .where { $0.status == .sent }
            .sorted(byKeyPath: "createdAt", ascending: false)
        return HeavenViewResultDto.of(flowerLogs.toArray())
    }
    
    private func updateFlower(flower: Flower, flowerLog: FlowerLog) {
        try! realm.write {
            flowerLog.flower = flower
        }
    }
    
    private func stringToObjectId(id: String) -> ObjectId {
        return try! ObjectId(string: id)
    }
    
    init(_ realm: Realm, _ repository: RealmRepository) {
        self.realm = realm
        self.repository = repository
    }
}
