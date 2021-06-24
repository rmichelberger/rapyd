//
//  Action.swift
//  rapyd
//
//  Created by Roland Michelberger on 21.06.21.
//

import Foundation

enum ActionType {
    case insurance, warranty(price: Money)
}

extension ActionType {
    var name: String {
        switch self {
        case .insurance:
            return "Travel Insurance"
        case .warranty:
            return "Extend Warranty"
        }
    }
    
    var providers: [ActionProvider] {
        switch self {
        case .insurance:
            return [
                ActionProvider(id: 1, company: "ERGO", imageURL: URL(string: "https://www.ergo.com.sg/wp-content/uploads/uploads_images/page_corporate_profile_ergo.jpg")!, name: "ERGO TravelProtect Essential", price: Money(amount: 17, currency: "SGD")),
                ActionProvider(id: 2, company: "MSIG", imageURL: URL(string: "https://www.msig.com.sg/sites/msig_sg/files/msig_logo_0_0.png")!, name: "MSIG TravelEasy Standard", price: Money(amount: 32, currency: "SGD")),
                ActionProvider(id: 3, company: "MSIG", imageURL: URL(string: "https://www.msig.com.sg/sites/msig_sg/files/msig_logo_0_0.png")!, name: "MSIG TravelEasy Pre-Ex Standard", price: Money(amount: 38, currency: "SGD")),
                ActionProvider(id: 4, company: "MSIG", imageURL: URL(string: "https://www.msig.com.sg/sites/msig_sg/files/msig_logo_0_0.png")!, name: "MSIG TravelEasy Elite", price: Money(amount: 44, currency: "SGD")),
                ActionProvider(id: 7, company: "MSIG", imageURL: URL(string: "https://www.msig.com.sg/sites/msig_sg/files/msig_logo_0_0.png")!, name: "MSIG TravelEasy Premier", price: Money(amount: 62, currency: "SGD")),
                ActionProvider(id: 5, company: "FWD", imageURL: URL(string: "https://fdwinsurance.com/wp-content/uploads/2021/04/2018_10_24_56955_1540345959._large.jpg")!, name: "FWD Premium", price: Money(amount: 10.5, currency: "SGD")),
                ActionProvider(id: 6, company: "FWD", imageURL: URL(string: "https://fdwinsurance.com/wp-content/uploads/2021/04/2018_10_24_56955_1540345959._large.jpg")!, name: "FWD Business", price: Money(amount: 16.5, currency: "SGD")),
                ActionProvider(id: 8, company: "FWD", imageURL: URL(string: "https://fdwinsurance.com/wp-content/uploads/2021/04/2018_10_24_56955_1540345959._large.jpg")!, name: "FWD First", price: Money(amount: 18.75, currency: "SGD")),
                
            ]
        case .warranty(let price):
            return [
                ActionProvider(id: 1, company: "Rapyd", imageURL: URL(string: "https://sboxiconslib.rapyd.net/merchant-logos/ohpc_f08148b4a0c6eeda3b3864eef01ff211.png")!, name: "Rapyd Basic\n- 1 year -", price: Money(amount: price.amount * 0.1, currency: price.currency)),
                ActionProvider(id: 2, company: "Rapyd", imageURL: URL(string: "https://sboxiconslib.rapyd.net/merchant-logos/ohpc_f08148b4a0c6eeda3b3864eef01ff211.png")!, name: "Rapyd Standard\n- 2 years -", price: Money(amount: price.amount * 0.22, currency: price.currency)),
                ActionProvider(id: 3, company: "Rapyd", imageURL: URL(string: "https://sboxiconslib.rapyd.net/merchant-logos/ohpc_f08148b4a0c6eeda3b3864eef01ff211.png")!, name: "Rapyd Premium\n- 3 years -", price: Money(amount: price.amount * 0.35, currency: price.currency)),
            ]
        }
    }
}
