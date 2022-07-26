//
//  DataAccessProvider.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/20.
//

import Foundation
import RealmSwift
import CoreData

// MARK: 기본적으로 id는 pet의 id입니다.
// MARK: pet의 id 이외에 다른 id를 받아야 하는 경우엔 parameter name을 명시적으로 작성했습니다.
// MARK: 함수 signature의 parameter type, return type을 잘 확인하고 이용해주세요!
protocol DataAccessService {
    // MARK: Pet 생성
    func addPet(_ inputDto: PetInputDto) -> Void
    
    // MARK: Pet 정보 가져오기
    func findPet(id: String) throws -> PetResultDto
    
    // MARK: 모든 Pet List 가져오기
    func findAllPet() -> Array<PetResultDto>
    
    // MARK: 편지 생성하기 (임시 저장 상태)
    func addLetter(_ inputDto: LetterInputDto) throws -> Void
    
    // MARK: 편지 저장하기 (저장 상태로 변경)
    func saveLetters(_ ids: String...) throws -> Void
    
    // MARK: 편지 임시저장 상태로 되돌리기 (임시저장 상태로 변경)
    func unsaveLetters(_ ids: String...) throws -> Void
    
    // MARK: 보내지 않은 편지 List 가져오기 (임시저장 상태 + 저장 상태)
    func findUnsentLetters(_ id: String) throws -> Array<LetterResultDto>
    
    // MARK: 보낸 편지 List 가져오기 (월별로)
    func findSentLetters(_ id: String, _ selected: String) throws -> Array<LetterResultDto>
    
    // MARK: 꽃 List 보여주기
    func findAllFlowers() -> Array<FlowerResultDto>
    
    // MARK: 꽃 선택하기 (보내지 않은 상태로 저장)
    func chooseFlower(petId: String, flowerId: String) throws -> Void
    
    // MARK: 편지와 꽃 보내기 (FlowerLog, Letter의 status를 모두 보냄 상태로 변경)
    func send(_ id: String) throws -> Void
    
    // MARK: 메인 뷰에 필요한 정보 가져오기 (선택한 꽃 Preview, 보내지 않은 편지 개수, 격려의 말)
    func getMainView(_ id: String) throws -> MainViewResultDto
    
    // MARK: 천국 뷰에 필요한 정보 가져오기 (강아지 사진, 가장 최근 꽃, 그 다음 최근 꽃 6개)
    func getHeavenView(_ id: String) throws -> HeavenViewResultDto
}
