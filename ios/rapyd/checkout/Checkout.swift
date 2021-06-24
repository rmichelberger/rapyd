//
//  Checkout.swift
//  rapyd
//
//  Created by Roland Michelberger on 11.06.21.
//

import Foundation

struct Checkout: Codable, Identifiable {
    let id: String
    let cancel_url: URL
    let complete_url: URL
    let merchant_logo: URL
    let amount: Double
    let currency: String
    let payment: Checkout.Payment
    let cart_items: [Product]?
    let timestamp: Double
    
    
    struct Payment: Codable {
        let description: String
        // description is holding the payment id
        var id: String { description }
    }
}

extension Checkout: Equatable {
    static func == (lhs: Checkout, rhs: Checkout) -> Bool {
        lhs.id == rhs.id
    }
}

extension Checkout {
    var money: Money {
        Money(amount: amount, currency: currency)
    }
    
    var formattedDate: String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter.string(from: date)
    }
    
    func contains(text: String) -> Bool {
        productNames.contains(where: { $0.localizedCaseInsensitiveContains(text) })
    }
    
    var productNames: [String] {
        guard let products = cart_items else { return [] }
        return products.map({ $0.name })
    }



}
