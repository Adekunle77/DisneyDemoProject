//
//  CharactersRepositoryTests.swift
//  DisneyDemoProjectTests
//
//  Created by Ade Adegoke on 27/04/2024.
//

import XCTest
@testable import DisneyDemoProject

@MainActor
class CharactersRepositoryTests: XCTestCase {

    var charactersRepository: CharactersRepository!
    var apiDataFetcher: MockAPIDataFetcher!
    var disneyCDPersistable: MockDisneyCDPersistence!
    var cache: MockCache!
    
    @MainActor override func setUpWithError() throws {
        apiDataFetcher = MockAPIDataFetcher()
        cache = MockCache()
        disneyCDPersistable = MockDisneyCDPersistence()
        charactersRepository = CharactersRepository(apiDataFetcher: apiDataFetcher, cache: cache, persistance: disneyCDPersistable)
    }

    @MainActor override func tearDownWithError() throws {
        charactersRepository = nil
        apiDataFetcher = nil
        cache = nil
        disneyCDPersistable = nil
    }

    
    func testDidGetDisneyCharactersSuccessfully() async throws {
        try await charactersRepository.getDisneyCharacters()
        XCTAssertEqual(charactersRepository.disneyCharacters.count, 50)
        XCTAssertEqual(charactersRepository.disneyCharacters.first?.name, "Achilles")
        
    }
    
    func testDidCacheDisneyCharacters()  async throws {
        try await charactersRepository.getDisneyCharacters()
        apiDataFetcher.isReturningError = true
    
        do {
            try await charactersRepository.getDisneyCharacters()
        } catch let error as APIError.NetworkFailure {
            XCTAssertTrue(error.code == 500 && error.message == "Response or data is nil")
        }
        XCTAssertEqual(charactersRepository.disneyCharacters.count, 50)
        XCTAssertEqual(charactersRepository.disneyCharacters.first?.name, "Achilles")
    }

    
}
