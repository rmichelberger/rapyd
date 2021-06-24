//
//  Payment.swift
//  rapyd
//
//  Created by Roland Michelberger on 10.06.21.
//

import Foundation

struct Payment: Codable {
    let original_amount: Double
    let currency_code: String
    let ewallet_id: String
    let paid: Bool?
}

extension Payment {
    var money: Money { Money(amount: original_amount, currency: currency_code) }
}
