//
//  Transfer.swift
//  rapyd
//
//  Created by Roland Michelberger on 10.06.21.
//

import Foundation

struct Transfer: Codable {
    let amount: Double
    let currency: String
    let source: String
    let destination: String
    
    init(money: Money, from: String, to: String) {
        amount = money.amount
        currency = money.currency
        source = from
        destination = to
    }
}
