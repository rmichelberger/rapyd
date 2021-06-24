//
//  RegistrationViewModel.swift
//  rapyd
//
//  Created by Roland Michelberger on 31.05.21.
//

import Foundation

final class RegistrationViewModel: ObservableObject {
    
    @Published var isRegistrationViewShown = false
    @Published private(set) var canRegister = false
    
    @Published private(set) var isLoading = false
    @Published var error: Error?
    
    @Published var profile: Profile {
        didSet {
            canRegister = isValid(profile: profile)
        }
    }
    
    private let store = DiskStore()
    
    init() {
        if let profile: Profile = store.get(key: .profile) {
            isRegistrationViewShown = profile.id.isEmpty
            self.profile = profile
        } else {
            profile = .empty
            isRegistrationViewShown = true
        }
//        self.profile.id = ""//"ewallet_431db06e852fac159382b19b43387fc1"
//        isRegistrationViewShown = false
    }
    
    private func isValid(profile: Profile) -> Bool {
        // todo: better validation
        guard let address = profile.address else { return false }
        let addressViewModel = AddressViewModel(address: address)
        
        return profile.firstName.isNotEmpty && profile.lastName.isNotEmpty && profile.email.isNotEmpty && addressViewModel.hasValidAddress
    }
    
    func register() {
        guard isValid(profile: profile) else { return }
        
        isLoading = true
        error = nil
        
        let url = Network.url(path: "/api/user")
        Network.post(url: url, body: profile) { [weak self] (result: Result<Id, Error>) in
            Main { self?.isLoading = false }
            switch result {
            case .failure(let error): Main { self?.error = error }
            case .success(let id):
                    Main {
                        self?.profile.id = id.id
                        self?.isRegistrationViewShown = false
                        do {
                            try self?.store.set(value: self?.profile, for: .profile)
                        } catch {
                            self?.error = error
                        }
                    }
            }
        }
    }
    
    enum RegistrationViewModelError: Error {
        case unknown
    }
    
    
}
