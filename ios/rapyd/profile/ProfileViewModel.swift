//
//  ProfileViewModel.swift
//  rapyd
//
//  Created by Roland Michelberger on 31.05.21.
//

import Foundation
import Combine

final class ProfileViewModel: ObservableObject {
    
//    @Published var name: String {
//        didSet {
//            if profile.name != name {
//                profile.name = name
//                save()
//            }
//        }
//    }
    
    @Published var email: String {
        didSet {
            if profile.email != email {
                profile.email = email
                save()
            }
        }
    }
    
    @Published var firstName: String {
        didSet {
            if profile.firstName != firstName {
                profile.firstName = firstName
                save()
            }
        }
    }
    
    @Published var lastName: String {
        didSet {
            if profile.lastName != lastName {
                profile.lastName = lastName
                save()
            }
        }
    }
    
    @Published var birthday: Date {
        didSet {
            if profile.birthday != birthday {
                profile.birthday = birthday
                save()
            }
        }
    }
    
    @Published var address: Address? {
        didSet {
            if profile.address != address {
                profile.address = address
                updateFormattedAddress()
                save()
            }
        }
    }
    
    @Published private(set) var formattedAddress = ""
    
    private var profile: Profile
    
    let profilePublisher = PassthroughSubject<Profile, Never>()

    init(profile: Profile) {
        self.profile = profile
//        name = profile.name
        
        email = profile.email
        firstName = profile.firstName
        lastName = profile.lastName
        birthday = profile.birthday
        address = profile.address
        
//        self.profile.address = Address(countryCode: "HU", state: "PERT", city: "ASDFS", zip: "SDF", street: "ASDFSDF")
        
        updateFormattedAddress()
    }
        
    private func updateFormattedAddress() {
        if let address = profile.address {
            let addressViewModel = AddressViewModel(address: address)
            let formattedAddress = addressViewModel.formattedAddress
            self.formattedAddress = formattedAddress.isEmpty ? "Your address" : formattedAddress
        } else {
            formattedAddress = "Your address"
        }
    }
    
    func save() {
        profilePublisher.send(profile)
    }
        
}
