//
//  ActionProvider.swift
//  rapyd
//
//  Created by Roland Michelberger on 22.06.21.
//

import Foundation

struct ActionProvider: Identifiable {
    let id: Int
    let company: String
    let imageURL: URL
    let name: String
    let price: Money
}

