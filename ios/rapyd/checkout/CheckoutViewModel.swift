//
//  CheckoutViewModel.swift
//  rapyd
//
//  Created by Roland Michelberger on 09.06.21.
//

import Foundation

final class CheckoutViewModel: ObservableObject {
    
    @Published private(set) var isLoading = false
    @Published private(set) var checkout: Checkout?
    @Published private(set) var error: Error?
    
    @Published private(set) var completedCheckouts = [Checkout]()
    
    private let store = DiskStore()
    
    func load(checkoutId: String) {
        
        if checkoutId.isNotEmpty {
            isLoading = true
            error = nil
            checkout = nil
            
            get(checkoutId: checkoutId) { [weak self] (result: Result<Checkout, Error>) in
                Main {
                    self?.isLoading = false
                    switch result {
                    case .failure(let error): self?.error = error
                    case .success(let checkout): self?.checkout = checkout
                    }
                }
            }
        }
    }
    
    private func get(checkoutId: String, completion: @escaping (Result<Checkout, Error>)-> Void) {
        let url = Network.url(path: "/api/checkouts/", queryItems: [URLQueryItem(name: "id", value: checkoutId)])
        Network.get(url: url, completion: completion)
    }
    
    func complete(checkout: Checkout) {
        do {
            if var completedCheckoutIds: [String] = store.get(key: .completedCheckoutIds) {
                completedCheckoutIds.append(checkout.id)
                try store.set(value: completedCheckoutIds, for: .completedCheckoutIds)
            } else {
                try store.set(value: [checkout.id], for: .completedCheckoutIds)
            }
            completedCheckouts.appendIfNotContains(checkout)
            completedCheckouts.sort(by: { $0.timestamp > $1.timestamp })
        } catch  {
            print(error)
        }
    }
    
    func loadCompletedCheckouts() {
        
//        try? store.set(value: ["checkout_cea62c956a1d45fae770ea4861d9465b"], for: .completedCheckoutIds)
        
        if let completedCheckoutIds: [String] = store.get(key: .completedCheckoutIds) {
            
            for checkoutId in completedCheckoutIds {
                get(checkoutId: checkoutId) { [weak self] result in
                    print(result)
                    switch result {
                    case .failure(let error): print(error)
                    case .success(let checkout): Main {
                        if self?.completedCheckouts.appendIfNotContains(checkout) ?? false {
                            self?.completedCheckouts.sort(by: { $0.timestamp > $1.timestamp })
                        }
                    }
                    }
                }
            }
        }
    }
    
}
