//
//  PaymentViewModel.swift
//  rapyd
//
//  Created by Roland Michelberger on 10.06.21.
//

import Foundation

final class PaymentViewModel: ObservableObject {
    
    @Published private(set) var isLoading = false
    
    @Published private(set) var payment: Payment?
    @Published private(set) var profile: Profile?
    
    func getPayment(id: String) {
        if id.isNotEmpty {
            isLoading = true
            
            let url = Network.url(path: "/api/payments/", queryItems: [URLQueryItem(name: "id", value: id)])
            Network.get(url: url) { [weak self] (result: Result<Payment, Error>) in
                Main { self?.isLoading = false }
                switch result {
                case .failure(let error): print(error)
                case .success(let payment):
                    Main {
                        self?.payment = payment
                        self?.getUser(id: payment.ewallet_id)
                    }
                }
            }
        }
    }
    
    func request(money: Money, walletId: String, completion: @escaping (Result<URL, Error>) -> Void) {
        isLoading = true
        createPayment(money: money, walletId: walletId) { [weak self] result in
            Main {
                self?.isLoading = false
                switch result {
                case .failure(let error): completion(.failure(error))
                case .success(let paymentId):
                    let shareURL = URL(string: "https://rapyd-pay.web.app/request?id=\(paymentId)")!
                    completion(.success(shareURL))
                }
            }
        }
    }
    
    func send(money: Money, walletId: String, completion: @escaping (Result<URL, Error>) -> Void) {
        isLoading = true
        createPayment(money: money, walletId: walletId) { [weak self] result in
            Main {
                self?.isLoading = false
                switch result {
                case .failure(let error): completion(.failure(error))
                case .success(let paymentId):
                    let shareURL = URL(string: "https://rapyd-pay.web.app/send?id=\(paymentId)")!
                    completion(.success(shareURL))
                }
            }
        }
    }
    
    private func createPayment(money: Money, walletId: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = Network.url(path: "/api/payments")
        let payment = CreatePayment(totalPrice: money, walletId: walletId)
        Network.post(url: url, body: payment) { (result: Result<Id, Error>) in
            switch result {
            case .failure(let error): completion(.failure(error))
            case .success(let paymentId): completion(.success(paymentId.id))
            }
        }
    }
    
    func getUser(id: String) {
        if id.isNotEmpty {
            isLoading = true
            
            let url = Network.url(path: "/api/user/", queryItems: [URLQueryItem(name: "id", value: id)])
            Network.get(url: url) { [weak self] (result: Result<[Contact], Error>) in
                Main { self?.isLoading = false }
                switch result {
                case .failure(let error): print(error)
                case .success(let contacts): Main { self?.profile = contacts.first?.profile }
                }
            }
        }
    }
    
    func move(money: Money, from: String, to: String, completion: @escaping (Error?) -> Void) {
        isLoading = true
        let url = Network.url(path: "/api/transfer")
        let transfer = Transfer(money: money, from: from, to: to)
        Network.post(url: url, body: transfer) { [weak self] (result: Result<String, Error>) in
            Main {
                self?.isLoading = false
                switch result {
                case .failure(let error): completion(error)
                case .success(_): completion(nil)
                }
            }
        }
    }
    
    func completePayment(id: String) {
        isLoading = true
        let url = Network.url(path: "/api/completePayment")
        let completePayment = CompletePayment(token: id)
        Network.post(url: url, body: completePayment) { [weak self] (result: Result<Payment, Error>) in
            Main {
                self?.isLoading = false
                switch result {
                case .failure(let error): print(error)
                case .success(let payment): self?.payment = payment
                }
            }
        }
    }
    
    
}
//https://rapyd-pay.web.app/request?id=payment_5bffaad78e0b6a518829f08719d744e7
