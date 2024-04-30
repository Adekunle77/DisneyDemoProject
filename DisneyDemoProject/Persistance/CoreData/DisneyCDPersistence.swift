//
//  DisneyCDPersistence.swift
//  DisneyDemoProject
//
//  Created by Ade Adegoke on 27/04/2024.
//

import CoreData

protocol DisneyCDPersistable {
    func saveDisneyCharacter(_ character: DisneyCharacter) async throws
    func retrieveDisneyCharacter(using id: Int) async throws -> DisneyCharacter?
    func deleteDisneyCharacter(using characterId: Int) async throws
    func retrieveAllDisneyCharacters() async throws -> [DisneyCharacter]
}

actor DisneyCDPersistence: DisneyCDPersistable {
    
    let persistence: CDPersistentable
    let coreDataStack: ContextSavable
    
    init(persistence: CDPersistentable = DIContainer.shared.resolve(type: CDPersistentable.self), coreDataStack: ContextSavable = DIContainer.shared.resolve(type: ContextSavable.self)) {
        self.persistence = persistence
        self.coreDataStack = coreDataStack
        
    }
    
    func saveDisneyCharacter(_ character: DisneyCharacter) async throws {
        guard let characterEntity = DisneyCharacterHelper.createCharacterEntity(with: character, using: coreDataStack) else {
            throw CDPersistenceError.saveError(NSError(domain: "Failed to create character entity", code: 0, userInfo: nil))
        }
        try await persistence.save(characterEntity)
    }

    func retrieveDisneyCharacter(using id: Int) async throws -> DisneyCharacter? {
        if let characterEntity: DisneyCharacterEntity = try await persistence.fetch(AppConstants.disneyCharacterEntity, using: id) {
            let character = DisneyCharacterHelper.createCharacter(with: characterEntity)
            return character
            
        }
        return nil
    }
    
    func retrieveAllDisneyCharacters() async throws -> [DisneyCharacter] {
         let entities = try await persistence.fetchAll(AppConstants.disneyCharacterEntity)
        
        var disneyCharacters: [DisneyCharacter] = []
        
        for entity in entities {
            guard let disneyCharacter = DisneyCharacterHelper.createCharacter(with: entity as? DisneyCharacterEntity) else { continue }
            disneyCharacters.append(disneyCharacter)
        }
        
        return disneyCharacters
    }

    func deleteDisneyCharacter(using characterId: Int) async throws {
        if let characterToDelete: DisneyCharacterEntity = try await persistence.fetch(AppConstants.disneyCharacterEntity, using: characterId) {
            try await persistence.delete(characterToDelete, using: characterId)
            
        } else {
            throw CDPersistenceError.deleteError(NSError(domain: "Character not found for deletion", code: 0, userInfo: nil))
        }
    }
}


