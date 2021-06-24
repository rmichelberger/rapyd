//
//  DiskStore.swift
//  rapyd
//
//  Created by Roland Michelberger on 31.05.21.
//

import Foundation

struct DiskStore {
    
    let userDefaults = UserDefaults.standard
    
    func get<T: Decodable>(key: Key) -> T? {
        guard let data = userDefaults.data(forKey: key.rawValue) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    func set<T: Encodable>(value: T, for key: Key) throws {
        let data = try JSONEncoder().encode(value)
        userDefaults.set(data, forKey: key.rawValue)
    }
    
    func delete(key: Key) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
    
    enum Key: String {
        case profile, urlsToHandle, completedCheckoutIds
    }
    
}
