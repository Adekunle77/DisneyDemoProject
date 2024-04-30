//
//  CDPersistence.swift
//  DisneyDemoProject
//
//  Created by Ade Adegoke on 27/04/2024.
//

import CoreData

protocol CDPersistentable {
    func save<T: NSManagedObject>(_ object: T) async throws
    func fetch<T: NSManagedObject>(_ object: String, using id: Int) async throws -> T?
    func fetchAll<T: NSManagedObject>(_ items: String) async throws -> [T]
    func delete<T: NSManagedObject>(_ object: T, using id: Int) async throws
    func saveAll<T: NSManagedObject>(_ objects: [T]) async throws
}

func typeName<T>(_ value: T) -> String {
    return String(describing: T.self)
}

func typeFromName<T>(_ typeName: String) -> T.Type? {
    return NSClassFromString(typeName) as? T.Type
}

enum CDPersistenceError: Error {
    case saveError(Error)
    case fetchError(Error)
    case deleteError(Error)
    case deleteAllError(Error)
}

actor CDPersistence: CDPersistentable {
 
    

    private let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func save<T: NSManagedObject>(_ object: T) async throws {
        do {
            try await persistentContainer.performBackgroundTask { context in
                let entityName = typeName(object)
                guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else { throw CDPersistenceError.saveError(NSError()) }
                let newObject = T(entity: entity, insertInto: context)
                let mirror = Mirror(reflecting: object)
                for child in mirror.children {
                    if let propertyName = child.label {
                        newObject.setValue(child.value, forKeyPath: propertyName)
                    }
                }
                Task {
                    do {
                        try await self.saveContext()
                    } catch {
                        throw CDPersistenceError.saveError(error)
                    }
                }
            }
        } catch {
            throw CDPersistenceError.saveError(error)
        }
    }
    
    func saveAll<T: NSManagedObject>(_ objects: [T]) async throws {
           try await withThrowingTaskGroup(of: Void.self) { group in
               for object in objects {
                   group.addTask {
                       do {
                           try await self.save(object)
                       } catch {
                           throw error
                       }
                   }
               }
               do {
                   try await group.waitForAll()
               } catch {
                   throw CDPersistenceError.saveError(error)
               }
           }
       }
    
    
    func fetch<T: NSManagedObject>(_ object: String, using id: Int) async throws -> T? {
        let fetchRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: object)
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        do {
            let result = try persistentContainer.viewContext.fetch(fetchRequest)
            return result.first as? T
        } catch {
            throw CDPersistenceError.fetchError(error)
        }
    }
    
    func fetchAll<T: NSManagedObject>(_ items: String) async throws -> [T] {
        let fetchRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: items)
        do {
            let result = try persistentContainer.viewContext.fetch(fetchRequest)
            return result as? [T] ?? []
        } catch {
            throw CDPersistenceError.fetchError(error)
        }
    }

    func delete<T: NSManagedObject>(_ object: T, using id: Int) async throws {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let fetchRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: typeName(object))
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            let result = try context.fetch(fetchRequest)
            if let objectToDelete = result.first as? NSManagedObject {
                
                context.delete(objectToDelete)
                try context.save()
            }
        } catch {
            throw CDPersistenceError.deleteError(error)
        }
    }

    private func saveContext() async throws  {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            throw CDPersistenceError.saveError(error)
        }
    }

}
