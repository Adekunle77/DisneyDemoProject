//
//  MockDisneyCDPersistence.swift
//  DisneyDemoProjectTests
//
//  Created by Ade Adegoke on 29/04/2024.
//

import XCTest
@testable import DisneyDemoProject

actor MockDisneyCDPersistence: DisneyCDPersistable {
     
    private (set) var disneyCharacters: [DisneyCharacter] = []
    
    func saveDisneyCharacter(_ character: DisneyCharacter) async throws {
        disneyCharacters.append(character)
    }
    
    func retrieveDisneyCharacter(using id: Int) async throws -> DisneyCharacter? {
        return disneyCharacters.first(where: { $0.id == id })
    }
    
    func deleteDisneyCharacter(using characterId: Int) async throws {
        disneyCharacters.removeAll(where: { $0.id == characterId })
    }
    
    func retrieveAllDisneyCharacters() async throws -> [DisneyCharacter] {
        return disneyCharacters
    }
}
