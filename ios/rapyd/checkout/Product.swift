//
//  Product.swift
//  rapyd
//
//  Created by Roland Michelberger on 17.06.21.
//

import Foundation

struct Product: Codable {
    let name: String
    let amount: Double
    let quantity: Int
    let image: String?
}

extension Product: Identifiable {
    var id: String { name }
}
