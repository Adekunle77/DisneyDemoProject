//
//  DisneyCharacter.swift
//  DisneyDemoProject
//
//  Created by Ade Adegoke on 26/04/2024.
//

import Foundation

struct DisneyAPIResponse: Codable {
    let apiInfo: DisneyAPIResponseInfo?
    let charactersData: [DisneyCharacter]
    
    enum CodingKeys: String, CodingKey {
        case apiInfo = "info"
        case charactersData = "data"
    }
}

struct DisneyCharacter: Codable, Identifiable {
    let id: Int?
    let films: [String]?
    let shortFilms: [String]?
    let sourceURL: String?
    let name: String?
    let imageUrl: String?
    let createdAt, updatedAt: String?
    let url: String?
    var imageData: Data?
    var isFavourite: Bool?
        
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case films, shortFilms, sourceURL, name, imageUrl, createdAt, updatedAt, url, imageData, isFavourite
    }
}



struct DisneyAPIResponseInfo: Codable {
    let count: Int?
    let totalPages: Int?
    let previousPage: String?
    let nextPage: String?
}

extension DisneyCharacter: Hashable {}

extension DisneyCharacter: Equatable {
    static func == (lhs: DisneyCharacter, rhs: DisneyCharacter) -> Bool {
        return lhs.id == rhs.id
    }
}
