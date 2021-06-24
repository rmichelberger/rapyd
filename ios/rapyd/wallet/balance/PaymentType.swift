//
//  PaymentType.swift
//  rapyd
//
//  Created by Roland Michelberger on 08.06.21.
//

import Foundation

struct PaymentType: Codable {
    let type: String
    let payment_flow_type: String
    let name: String
    let image: URL
    let currencies: [String]
    
    var paymentFlowType: PaymentFlowType {
        PaymentFlowType(rawValue: payment_flow_type) ?? .unknown
    }
}

extension PaymentType: Identifiable {
    var id: String { type }
}

enum PaymentFlowType: String, Codable {
    case unknown, redirect_url, cash, card, bank_transfer
}
