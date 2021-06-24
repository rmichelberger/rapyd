//
//  WalletViewModel.swift
//  rapyd
//
//  Created by Roland Michelberger on 07.06.21.
//

import Foundation

final class WalletViewModel: ObservableObject {
    
    @Published private(set) var isLoading = false
    
    @Published private(set) var balances = [Balance]()
    
    @Published var profile: Profile {
        didSet {
            print("did set")
            loadBalances()
        }
    }
    
    init(profile: Profile) {
        self.profile = profile
//        print("init")
//        loadBalances()
    }
    
    func loadBalances() {
        
        print("loadBalances", profile.id)
        if profile.id.isNotEmpty {
            
            isLoading = true
            let url = Network.url(path: "/api/balance/", queryItems: [URLQueryItem(name: "id", value: profile.id)])
            Network.get(url: url) { [weak self] (result: Result<[Balance], Error>) in
                Main { self?.isLoading = false }
                switch result {
                case .failure(let error): print(error)
                case .success(let balances): Main { self?.balances = balances }
                }
            }
        }
    }
    
    func addFund(money: Money, completion: @escaping (Error?) -> Void) {
        isLoading = true
        let url = Network.url(path: "/api/deposit")
        let fund = Fund(money: money, walletId: profile.id)
        Network.post(url: url, body: fund) { [weak self] (result: Result<String, Error>) in
            Main {
                self?.isLoading = false
                switch result {
                case .failure(let error): completion(error)
                case .success(_): completion(nil)
                }
            }
        }
    }
    
}
