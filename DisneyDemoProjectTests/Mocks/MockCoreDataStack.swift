//
//  MockCoreDataStack.swift
//  DisneyDemoProjectTests
//
//  Created by Ade Adegoke on 28/04/2024.
//

import XCTest
import CoreData
@testable import DisneyDemoProject

class MockCoreDataStack: ContextSavable {
    
    let context: NSManagedObjectContext
    let persistentContainer: NSPersistentContainer
    
    init() {
        self.persistentContainer = NSPersistentContainer(name: AppConstants.disneyCDModelName)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        self.persistentContainer.persistentStoreDescriptions = [description]
        self.persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        self.context = persistentContainer.viewContext
    }
    
    func saveContext() async throws {
        guard context.hasChanges else { return }
        
        do {
            try await context.perform {
                try self.context.save()
            }
        } catch {
            throw error
        }
    }
}
