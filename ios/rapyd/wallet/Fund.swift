//
//  Fund.swift
//  rapyd
//
//  Created by Roland Michelberger on 08.06.21.
//

import Foundation

struct Fund: Codable {
    let amount: Double
    let currency: String
    let walletId: String
    
    init(money: Money, walletId: String) {
        amount = money.amount
        currency = money.currency
        self.walletId = walletId
    }
}
