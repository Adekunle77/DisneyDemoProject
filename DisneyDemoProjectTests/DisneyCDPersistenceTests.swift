//
//  DisneyCDPersistenceTests.swift
//  DisneyDemoProjectTests
//
//  Created by Ade Adegoke on 28/04/2024.
//

import XCTest
@testable import DisneyDemoProject

class DisneyCDPersistenceTests: XCTestCase {
    
    var disneyCDPersistence: DisneyCDPersistence!
    var coreDataStack: MockCoreDataStack!
    var persistence: MockCDPersistence!

    override func setUpWithError() throws {
        persistence = MockCDPersistence()
        coreDataStack = MockCoreDataStack()
        disneyCDPersistence = DisneyCDPersistence(persistence: persistence, coreDataStack: coreDataStack)
    }

    override func tearDownWithError() throws {
        persistence = nil
        coreDataStack = nil
        disneyCDPersistence = nil
    }

    func testDidSaveAndRetrieveDisneyCharacter() async throws {
        guard let loadedData = try StubsData.loadJson(filename: AppConstants.disneyCharacterStubsfileName), let disneyCharacter = loadedData.charactersData.first, let id = disneyCharacter.id else { return }
        
        try await disneyCDPersistence.saveDisneyCharacter(disneyCharacter)
        
        if let savedCharacterID = try await disneyCDPersistence.retrieveDisneyCharacter(using: id)?.id {
            XCTAssertEqual(id, savedCharacterID)
        } else {
            XCTFail("Failed to fetch DisneyCharacterEntity")
        }
    }
    
    func testDeleteDisneyCharacter() async throws {
        guard let loadedData = try StubsData.loadJson(filename: AppConstants.disneyCharacterStubsfileName), let disneyCharacter = loadedData.charactersData.first, let id = disneyCharacter.id else { return }
        
        try await disneyCDPersistence.saveDisneyCharacter(disneyCharacter)
        try await disneyCDPersistence.deleteDisneyCharacter(using: id)
        
        let savedDisneyCharacter = try await disneyCDPersistence.retrieveDisneyCharacter(using: id)

        XCTAssertNil(savedDisneyCharacter)
    }
    
}
