//
//  MockCDPersistence.swift
//  DisneyDemoProjectTests
//
//  Created by Ade Adegoke on 27/04/2024.
//

import XCTest
import CoreData
@testable import DisneyDemoProject

class MockCDPersistence: CDPersistentable {

    

    var savedObjects: [NSManagedObject] = []

    func save<T: NSManagedObject>(_ object: T) async {
        savedObjects.append(object)
    }

    func fetch<T: NSManagedObject>(_ object: String, using id: Int) async -> T? {
        guard let objectType = typeFromName(T.self, object) else {
            return nil
        }

        let filteredObjects = savedObjects.filter { obj in
            return obj.isKind(of: objectType)
        }.compactMap { $0 as? T }

        return filteredObjects.first
    }
    
    func saveAll<T: NSManagedObject>(_ objects: [T]) async throws {
        for object in objects {
            savedObjects.append(object)
        }
    }

    func fetchAll<T>(_ items: String) async throws -> [T] where T : NSManagedObject {
        guard let objectType = typeFromName(T.self, items) else {
            return []
        }
        
        return savedObjects.filter { obj in
            return obj.isKind(of: objectType)
        }.compactMap { $0 as? T }
    }

    func delete<T: NSManagedObject>(_ object: T, using id: Int) async throws {
        guard let objectType = typeFromName(T.self, typeName(object)) else {
            return
        }

        guard let index = savedObjects.firstIndex(where: { obj in
            return obj.isKind(of: objectType)
        }) else {
            throw PersistenceError.objectNotFound
        }
        savedObjects.remove(at: index)
    }

    private func typeFromName<T>(_ type: T.Type, _ typeName: String) -> T.Type? {
        return NSClassFromString(typeName) as? T.Type
    }
}

enum PersistenceError: Error {
    case objectNotFound
}
