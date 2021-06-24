//
//  Balance.swift
//  rapyd
//
//  Created by Roland Michelberger on 07.06.21.
//

import Foundation

struct Balance: Codable, Identifiable {
    let id: String
    let currency: String
    let balance: Double
    let alias: String
}
