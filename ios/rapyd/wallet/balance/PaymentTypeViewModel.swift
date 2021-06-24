//
//  PaymentTypeViewModel.swift
//  rapyd
//
//  Created by Roland Michelberger on 08.06.21.
//

import Foundation

final class PaymentTypeViewModel: ObservableObject {
    
    @Published private(set) var isLoading = false
    
    @Published private(set) var cashPaymentTypes = [PaymentType]()
    @Published private(set) var cardPaymentTypes = [PaymentType]()
    @Published private(set) var bankPaymentTypes = [PaymentType]()
    
    init() {
        load()
    }
    
    func load() {
        
        cardPaymentTypes.removeAll()
        cashPaymentTypes.removeAll()
        bankPaymentTypes.removeAll()
        
        isLoading = true
 
        let url = Network.url(path: "/api/paymenttype/", queryItems: [URLQueryItem(name: "country", value: Locale.current.regionCode)])
        Network.get(url: url) { [weak self] (result: Result<[PaymentType], Error>) in
            Main { self?.isLoading = false }
            switch result {
            case .failure(let error): print(error)
            case .success(let paymentTypes): Main {
                self?.cashPaymentTypes = paymentTypes.filter({ $0.paymentFlowType == .cash })
                self?.cardPaymentTypes = paymentTypes.filter({ $0.paymentFlowType == .card })
                self?.bankPaymentTypes = paymentTypes.filter({ $0.paymentFlowType == .bank_transfer })
                
            }
            }
        }
    }
    
}
