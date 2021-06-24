//
//  Address.swift
//  rapyd
//
//  Created by Roland Michelberger on 31.05.21.
//

import Foundation

struct Address: Codable, Equatable {
    var countryCode: String
    var state: String
    var city: String
    var zip: String
    var street: String
}

extension Address {
    static let empty = Address(countryCode: "", state: "", city: "", zip: "", street: "")
    
    init?(contact: Contact) {
        guard let address = contact.address else {
            return nil
        }
        
        self.countryCode = address.country ?? ""
        self.state = address.state ?? ""
        self.city = address.city ?? ""
        self.zip = address.zip ?? ""
        self.street = address.line_1 ?? ""
        
    }
}
