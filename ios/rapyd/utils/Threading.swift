//
//  Threading.swift
//  rapyd
//
//  Created by Roland Michelberger on 01.06.21.
//

import Foundation

struct Main {
    
    @discardableResult
    init(after: DispatchTime? = nil, execute: @escaping @convention(block) () -> Void) {
        run(dispatchQueue: DispatchQueue.main, after: after, execute: execute)
    }
}

struct Background {
    
    @discardableResult
    init(after: DispatchTime? = nil, queue: BackgroundQueue, execute: @escaping @convention(block) () -> Void) {
        run(dispatchQueue: queue.dispatchQueue, after: after, execute: execute)
    }
}

//fileprivate struct Queue {
    
    fileprivate func run(dispatchQueue: DispatchQueue, after: DispatchTime? = nil, execute: @escaping @convention(block) () -> Void) {
        if let after = after {
            dispatchQueue.asyncAfter(deadline: after, execute: execute)
        } else {
            dispatchQueue.async(execute: execute)
        }
    }
//}

enum BackgroundQueue: String {
    case global, fileStore, accountList, profileList
    
    var dispatchQueue: DispatchQueue {
        switch self {
        case .global:
            return DispatchQueue.global()
        default:
            guard let queue = BackgroundQueue.dispatchQueues[self] else {
                let queue = DispatchQueue(label: self.rawValue)
                BackgroundQueue.dispatchQueues[self] = queue
                return  queue
                
            }
            return  queue
        }
    }
    
    private static var dispatchQueues = [BackgroundQueue:DispatchQueue]()
}
