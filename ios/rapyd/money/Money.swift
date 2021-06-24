//
//  Money.swift
//  rapyd
//
//  Created by Roland Michelberger on 10.06.21.
//

import Foundation

struct Money: Codable {

    var amount: Double
    var currency: String
    
    var fomattedString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "-"
    }
}

#if DEBUG
extension Money {
    static let empty = Money(amount: 0, currency: "")
}
#endif
