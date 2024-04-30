//
//  MockCache.swift
//  DisneyDemoProjectTests
//
//  Created by Ade Adegoke on 27/04/2024.
//

import XCTest
@testable import DisneyDemoProject

final class MockCache: Cacheable {
    var storage: [String: Sendable] = [:]
    
    func insert(_ value: Sendable, forKey key: String) {
        storage[key] = value
    }
    
    func value(forKey key: String) -> Sendable? {
        return storage[key]
    }
    
    func removeValue(forKey key: String) {
        storage.removeValue(forKey: key)
    }
    
    subscript(key: String) -> Sendable? {
        get { return value(forKey: key) }
        set {
            guard let value = newValue else {
                removeValue(forKey: key)
                return
            }
            
            insert(value, forKey: key)
        }
    }
}
