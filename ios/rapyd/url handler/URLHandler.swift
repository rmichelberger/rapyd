//
//  URLHandler.swift
//  rapyd
//
//  Created by Roland Michelberger on 09.06.21.
//

import Foundation

final class URLHandler: ObservableObject {
    
    static let shared = URLHandler()

    private let store = DiskStore()
    
    @Published private(set) var checkoutIds = [String]()
    @Published private(set) var requestMoneyIds = [String]()
    @Published private(set) var sendMoneyIds = [String]()

    private var urls = [URL]()
    
    private init() {
//        store.delete(key: .urlsToHandle)
        if let urls: [URL] = store.get(key: .urlsToHandle) {
            self.urls = urls
            for url in urls {
                handle(url: url)
            }
        }
        
//        handle(url: URL(string: "https://rapyd-pay.web.app/checkout/checkout.html?id=checkout_558bf02e31cc1d4873da98d651532e62")!)
//                handle(url: URL(string: "https://rapyd-pay.web.app/request?id=payment_7323d23f59151cbe22392a0cc2319ca8")!)
//        handle(url: URL(string: "http://localhost:5000/checkout/checkout.html?id=checkout_cea62c956a1d45fae770ea4861d9465b")!)
//        handle(url: URL(string: "http://localhost:5000/checkout/checkout.html?id=checkout_1d2addfc08cd2a0a34d2d557013e2aa1")!)
    }
    
    @discardableResult
    func handle(url: URL) -> Bool {

        var handled = false
        if let id = checkoutId(from: url) {
            checkoutIds.append(id)
            handled = true
        } else if let id = sendMoneyId(from: url) {
            sendMoneyIds.append(id)
            handled = true
        } else if let id = requestMoneyId(from: url) {
            requestMoneyIds.append(id)
            handled = true
        }
        
        if handled {
            urls.append(url)
            storeUrls()
        }

        return handled
    }
    
    private func checkoutId(from url: URL) -> String? {
        guard url.pathComponents.contains("checkout"), let id = url.components.queryItems.first(where: { $0.name == "id" })?.value else {
            return nil
        }
        
        return id
    }
    
    func checkoutFinished(id: String) {
        checkoutIds.remove(id)
        urls.removeAll(where: { checkoutId(from: $0) == id })
        storeUrls()
    }
    
    private func sendMoneyId(from url: URL) -> String? {
        guard url.pathComponents.contains("send"), let id = url.components.queryItems.first(where: { $0.name == "id" })?.value else {
            return nil
        }
        
        return id
    }
    
    func sendMoneyFinished(id: String) {
        sendMoneyIds.remove(id)
        urls.removeAll(where: { sendMoneyId(from: $0) == id })
        storeUrls()
    }

    private func requestMoneyId(from url: URL) -> String? {
        guard url.pathComponents.contains("request"), let id = url.components.queryItems.first(where: { $0.name == "id" })?.value else {
            return nil
        }
        
        return id
    }
    
    func requestMoneyFinished(id: String) {
        requestMoneyIds.remove(id)
        urls.removeAll(where: { requestMoneyId(from: $0) == id })
        storeUrls()
    }
    
    private func storeUrls() {
        do {
            try store.set(value: urls, for: .urlsToHandle)
        } catch  {
            print(error)
        }
    }

}
