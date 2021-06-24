//
//  Profile.swift
//  rapyd
//
//  Created by Roland Michelberger on 31.05.21.
//

import Foundation

struct Profile: Codable, Identifiable, Equatable {
    var id: String
    var firstName: String
    var lastName: String
    var email: String
    var address: Address?
    var birthday: Date
}

extension Profile {
//    static let empty = Profile(id: "", firstName: "", lastName: "", email: "", address: nil, birthday: nil)
    static let empty = Profile(id: "", firstName: "", lastName: "", email: "", address: .empty, birthday: Date(timeIntervalSinceNow: TimeInterval(-30*365*24*60*60)))
    
    var initiale: String {
        NameFormatter.initiale(firstName: firstName, lastName: lastName)
    }
    
    var name: String {
        NameFormatter.name(firstName: firstName, lastName: lastName)
    }
}
