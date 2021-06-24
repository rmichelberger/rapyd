//
//  AddressViewModel.swift
//  rapyd
//
//  Created by Roland Michelberger on 31.05.21.
//

import Foundation
import Contacts
import Combine

final class AddressViewModel: ObservableObject {
    
    @Published var country: Country {
        didSet {
            if address.countryCode != country.code {
                address.countryCode = country.code
                updateFormattedAddress()
                save()
            }
        }
    }
        
    @Published var state: String {
        didSet {
            if address.state != state {
                address.state = state
                updateFormattedAddress()
                save()
            }
        }
    }
    @Published var city: String {
        didSet {
            if address.city != city {
                address.city = city
                updateFormattedAddress()
                save()
            }
        }
    }
    
    @Published var zip: String {
        didSet {
            if address.zip != zip {
                address.zip = zip
                updateFormattedAddress()
                save()
            }
        }
    }
    
    @Published var street: String {
        didSet {
            if address.street != street {
                address.street = street
                updateFormattedAddress()
                save()
            }
        }
    }

    @Published private(set) var formattedAddress: String
    
    private var address: Address
//    @Published private(set) var chagedAddress: Address
    
    let addressPublisher = PassthroughSubject<Address, Never>()

    init(address: Address) {
        self.country = Country(code: address.countryCode) ?? .empty
        self.address = address
        formattedAddress = "Set address (optional)"
        state = address.state
        city = address.city
        zip = address.zip
        street = address.street
        updateView()
    }
        
    private func updateView() {
        
        state = address.state
        city = address.city
        zip = address.zip
        street = address.street

        updateFormattedAddress()
    }
    
    private func updateFormattedAddress() {
        let postalAddress = CNMutablePostalAddress()
        postalAddress.street = address.street
        postalAddress.postalCode = address.zip
        postalAddress.city = address.city
        postalAddress.state = address.state
        postalAddress.country = country.name
        postalAddress.isoCountryCode = address.countryCode
        formattedAddress = CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress)
    }
    
    private func save() {
        addressPublisher.send(address)
    }
    
    var hasValidAddress: Bool {
        return formattedAddress.isNotEmpty
    }

    
}
