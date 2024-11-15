//
//  CoinModel.swift
//  CoinDoc
//
//  Created by Aswin S on 12/11/24.
//

import Foundation

struct CryptoCoin: Codable {
    let name : String
    let symbol : String
    let isNew : Bool
    let isActive : Bool
    let type : String
    
    enum CodingKeys: String, CodingKey {
        case name
        case symbol
        case isNew = "is_new"
        case isActive = "is_active"
        case type
    }
}
