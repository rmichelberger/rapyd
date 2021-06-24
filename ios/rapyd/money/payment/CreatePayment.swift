//
//  CreatePayment.swift
//  rapyd
//
//  Created by Roland Michelberger on 10.06.21.
//

import Foundation

struct CreatePayment: Codable {
    let totalPrice: Money
    let walletId: String
}
