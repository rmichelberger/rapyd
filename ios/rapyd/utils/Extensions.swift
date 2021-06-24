//
//  Extensions.swift
//  rapyd
//
//  Created by Roland Michelberger on 31.05.21.
//

import Combine
import SwiftUI

var isIpad: Bool = UIDevice.current.userInterfaceIdiom == .pad
var isIphone: Bool = UIDevice.current.userInterfaceIdiom == .phone

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension Collection {
    
    var isNotEmpty: Bool {
        !isEmpty
    }
}

extension Collection where Element: Cancellable {
    func cancelAll() { forEach({ $0.cancel() })}
}


extension RangeReplaceableCollection where Element: Equatable {
    
    mutating func remove(_ element: Element) {
        removeAll(where: { $0 == element })
    }
    
    @discardableResult
    mutating func appendIfNotContains(_ element: Element) -> Bool {
        if contains(element) {
            return false
        } else {
            append(element)
            return true
        }
    }
}
    

extension JSONEncoder {
    
//    class var encoder: JSONEncoder { JSONEncoder() }
    class var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970
        return encoder
    }
    
}

extension JSONDecoder {

//    class var decoder: JSONDecoder { JSONDecoder() }
    class var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return decoder
    }

}

extension URLResponse {
    
    var status: Int {
        (self as? HTTPURLResponse)?.statusCode ?? 0
    }
}

func debugLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
//        print(items, separator: separator, terminator: terminator)
    #endif
}


extension String {
    
    func remove(characters: CharacterSet) -> String {
        components(separatedBy: characters).filter { $0.count > 0 }.joined(separator: "")
    }    
}
