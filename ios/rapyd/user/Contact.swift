//
//  Contact.swift
//  rapyd
//
//  Created by Roland Michelberger on 10.06.21.
//

import Foundation

struct Contact: Codable {
    let id: String?
    let first_name: String?
    let last_name: String?
    let email: String?
    let date_of_birth: String?
    let address: ContactAddress?
    let country: String?
}

struct ContactAddress: Codable {
    let line_1: String?
    let city: String?
    let country: String?
    let state: String?
    let zip: String?
}

extension Contact {
    
    private var birthday: Date {
        guard let date = date_of_birth else { return Date() }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: date) ?? Date()
    }
    
    var profile: Profile {
        Profile(id: id ?? "", firstName: first_name ?? "", lastName: last_name ?? "", email: email ?? "", address: Address(contact: self), birthday: birthday)
    }
}
