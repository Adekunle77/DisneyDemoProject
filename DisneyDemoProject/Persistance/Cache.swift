//
//  Cache.swift
//  DisneyDemoProject
//
//  Created by Ade Adegoke on 26/04/2024.
//

import Foundation

protocol Cacheable {
    func insert(_ value: Sendable, forKey key: String)
    func value(forKey key: String) -> Sendable?
    func removeValue(forKey key: String)
    subscript(key: String) -> Sendable? { get set }
}


final class Cache: Cacheable {
    private let wrapped = NSCache<NSString, Entry>()
    private let lock = NSLock()
    
    func insert(_ value: Sendable, forKey key: String) {
        lock.lock()
        defer { lock.unlock() }
        let entry = Entry(value: value)
        wrapped.setObject(entry, forKey: key as NSString)
    }
    
    func value(forKey key: String) -> Sendable? {
        lock.lock()
        defer { lock.unlock() }
        let entry = wrapped.object(forKey: key as NSString)
        return entry?.value
    }
    
    func removeValue(forKey key: String) {
        lock.lock()
        defer { lock.unlock() }
        wrapped.removeObject(forKey: key as NSString)
    }
}

private extension Cache {
    final class Entry {
        let value: Sendable
        
        init(value: Sendable) {
            self.value = value
        }
    }
}

extension Cache {
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
