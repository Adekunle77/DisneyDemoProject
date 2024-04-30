//
//  CDPersistenceTests.swift
//  DisneyDemoProjectTests
//
//  Created by Ade Adegoke on 28/04/2024.
//

import XCTest
import CoreData
@testable import DisneyDemoProject

class CDPersistenceTests: XCTestCase {
    
    var persistence: CDPersistence!
    var coreDataStack: MockCoreDataStack!
    
    override func setUpWithError() throws {
        coreDataStack = MockCoreDataStack()
        persistence = CDPersistence(persistentContainer: coreDataStack.persistentContainer)
    }

    override func tearDownWithError() throws {
        persistence = nil
    }

    
    func testFetchAllObject() async throws {
        guard let loadedData = try StubsData.loadJson(filename: AppConstants.disneyCharacterStubsfileName) else { return }
        
        var entities: [DisneyCharacterEntity] = []
        
        for data in loadedData.charactersData {
            guard let entity = DisneyCharacterHelper.createCharacterEntity(with: data, using: coreDataStack) else { continue }
            entities.append(entity)
        }
        
        try await persistence.saveAll(entities)
        
        if let savedEntities = try await persistence.fetchAll(AppConstants.disneyCharacterEntity) as? [DisneyCharacterEntity] {
            XCTAssertEqual(savedEntities.count, entities.count)
        } else {
            XCTFail("Failed to fetch DisneyCharacterEntity")
        }
    }
    
    
    func testSaveAndFetchObject() async throws {
        guard let loadedData = try StubsData.loadJson(filename: AppConstants.disneyCharacterStubsfileName), let disneyCharacter = loadedData.charactersData.first, let characterEntity = DisneyCharacterHelper.createCharacterEntity(with: disneyCharacter, using: coreDataStack) else { return }
        
        try await persistence.save(characterEntity)
        
        if let savedEntity = try await persistence.fetch(AppConstants.disneyCharacterEntity, using: disneyCharacter.id ?? 0) as? DisneyCharacterEntity {
            let savedDisneyCharacter = DisneyCharacterHelper.createCharacter(with: savedEntity)
            XCTAssertEqual(savedDisneyCharacter?.id, disneyCharacter.id)
        } else {
            XCTFail("Failed to fetch DisneyCharacterEntity")
        }
    }
    
    func testDeleteObject() async throws {
        guard let loadedData = try StubsData.loadJson(filename: AppConstants.disneyCharacterStubsfileName), let disneyCharacter = loadedData.charactersData.first, let characterEntity = DisneyCharacterHelper.createCharacterEntity(with: disneyCharacter, using: coreDataStack) else { return }

        try await persistence.save(characterEntity)
        try await persistence.delete(characterEntity, using: disneyCharacter.id ?? 0)
 
        let savedEntity = try await persistence.fetch(AppConstants.disneyCharacterEntity, using: disneyCharacter.id ?? 0) as? DisneyCharacterEntity

        XCTAssertNil(savedEntity)
    }
    
    private func disCharacterEntities() throws -> [DisneyCharacterEntity] {
        guard let loadedData = try StubsData.loadJson(filename: AppConstants.disneyCharacterStubsfileName) else { return [] }
        
        var entities: [DisneyCharacterEntity] = []
        
        for data in loadedData.charactersData {
            guard let entity = DisneyCharacterHelper.createCharacterEntity(with: data, using: coreDataStack) else { continue }
            entities.append(entity)
        }
       return entities
    }

}

