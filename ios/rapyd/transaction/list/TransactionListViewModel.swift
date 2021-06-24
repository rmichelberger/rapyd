//
//  TransactionListViewModel.swift
//  rapyd
//
//  Created by Roland Michelberger on 08.06.21.
//

import Foundation

final class TransactionListViewModel: ObservableObject {
    
    @Published private(set) var isLoading = false
    
    @Published private(set) var transactions = [Transaction]()
    
    func load(walletId: String) {
        if walletId.isNotEmpty {
            isLoading = true
            
            let url = Network.url(path: "/api/transactions/", queryItems: [URLQueryItem(name: "id", value: walletId)])
            Network.get(url: url) { [weak self] (result: Result<[Transaction], Error>) in
                Main { self?.isLoading = false }
                switch result {
                case .failure(let error): print(error)
                case .success(let transactions): Main { self?.transactions = transactions.sorted(by: { $0.created_at > $1.created_at }) }
                }
            }
        }
    }
}
