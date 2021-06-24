//
//  NameFormatter.swift
//  rapyd
//
//  Created by Roland Michelberger on 07.06.21.
//

import Foundation

class NameFormatter {
    
    class func initiale(firstName: String, lastName: String) -> String {
        let formatter = PersonNameComponentsFormatter()
        var nameComponents = PersonNameComponents()
        if let c = firstName.first {
            nameComponents.givenName = String(c)
        }
        if let c = lastName.first {
            nameComponents.familyName = String(c)
        }
        return formatter.string(from: nameComponents).remove(characters: CharacterSet.whitespacesAndNewlines)
    }
    
    class func name(firstName: String, lastName: String) -> String {
        let formatter = PersonNameComponentsFormatter()
        var nameComponents = PersonNameComponents()
        nameComponents.givenName = firstName
        nameComponents.familyName = lastName
        return formatter.string(from: nameComponents)
    }
    
}
