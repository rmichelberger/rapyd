//
//  Country.swift
//  rapyd
//
//  Created by Roland Michelberger on 31.05.21.
//

import Foundation

struct Country: Codable {
    let code: String
    let name: String
    
    init?(code: String) {
        guard let name = Locale.current.localizedString(forRegionCode: code) else { return nil }
        self.code = code
        self.name =  name
    }
    
    private init() {
        code = ""
        name = ""
    }
}

extension Country: Identifiable {
    var id: String { code }
    
    static var empty = Country()
}
