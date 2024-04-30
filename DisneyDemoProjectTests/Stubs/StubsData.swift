//
//  StubsData.swift
//  DisneyDemoProjectTests
//
//  Created by Ade Adegoke on 27/04/2024.
//

import XCTest
@testable import DisneyDemoProject

struct StubsData {
    static func loadJson(filename fileName: String) throws -> DisneyAPIResponse? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let disneyAPIResponse = try decoder.decode(DisneyAPIResponse.self, from: data)
               
                return disneyAPIResponse
            } catch {
                print("Error!! Unable to parse \(fileName).json")
                throw error
            }
        }
        return nil
    }
    
}
