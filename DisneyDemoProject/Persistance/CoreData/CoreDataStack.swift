//
//  CoreDataStack.swift
//  DisneyDemoProject
//
//  Created by Ade Adegoke on 27/04/2024.
//

import CoreData

protocol ContextSavable {
    func saveContext() async throws
    var context: NSManagedObjectContext { get }
    var persistentContainer: NSPersistentContainer { get }
}

actor CoreDataStack: ContextSavable {
    
    let context: NSManagedObjectContext
    let persistentContainer: NSPersistentContainer
    
    init() {
        self.persistentContainer = NSPersistentContainer(name: AppConstants.disneyCDModelName)
        self.context = persistentContainer.viewContext
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func saveContext() async throws {
        guard context.hasChanges else { return }
        
        do {
            try context.performAndWait {
                try context.save()
            }
        } catch {
            throw error
        }
    }
}
