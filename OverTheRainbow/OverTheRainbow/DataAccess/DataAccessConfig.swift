//
//  DataAccessConfig.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/22.
//

import Foundation

protocol DataAccessConfig {
    func getService() ->  DataAccessService
}
