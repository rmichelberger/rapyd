//
//  DataLoader.swift
//  rapyd
//
//  Created by Roland Michelberger on 08.06.21.
//

import Foundation
import Combine

final class DataLoader: ObservableObject {
    
    private let url: URL
    private var task: URLSessionDataTask? = nil
    private var data: Data? = nil
    
    var didLoad = PassthroughSubject<Data, Never>()
    
    init(url: URL) {
        self.url = url
    }
    
    func load() {
        guard let data = data else {
            task?.cancel()
            task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else { return }
                DispatchQueue.main.async { [weak self] in
                    self?.data = data
                    self?.didLoad.send(data)
                }
            }
            task?.resume()
            return
        }
        
        didLoad.send(data)
        
    }
}
