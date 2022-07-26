//
//  HeavenViewResultDto.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/22.
//

import Foundation

struct HeavenViewResultDto {
    var lastFlower: FlowerResultDto?
    var recentFlowers: Array<FlowerResultDto> = Array<FlowerResultDto>()
    
    public static func of(_ flowerLogs: Array<FlowerLog>) -> HeavenViewResultDto {
        return HeavenViewResultDto(flowerLogs)
    }
    
    private init(_ flowerLogs: Array<FlowerLog>) {
        for (idx, flowerLog) in flowerLogs.enumerated() {
            if idx == 0 { lastFlower = FlowerResultDto.of(flowerLog.flower!) }
            else { recentFlowers.append(FlowerResultDto.of(flowerLog.flower!)) }
        }
    }
}
