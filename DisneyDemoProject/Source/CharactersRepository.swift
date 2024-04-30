//
//  CharactersRepository.swift
//  DisneyDemoProject
//
//  Created by Ade Adegoke on 26/04/2024.
//

import Combine
import Foundation


protocol CharactersRepositoryable {
    func getDisneyCharacters() async throws
    func getSavedDisneyCharacters() async throws -> [DisneyCharacter]
    func saveFavorite(_ character: DisneyCharacter) async throws
    func deleteDisneyCharacters(_ character: DisneyCharacter) async throws
    func getDisneyCharactersWithImages() async throws
    @MainActor var disneyCharacters: [DisneyCharacter] { get }
}

enum CharactersRepositoryError: Error {
    case apiUrlErrror
}

@MainActor
final class CharactersRepository: CharactersRepositoryable, ObservableObject {
    
    private let apiDataFetcher: DataFetchable
    private let persistance: DisneyCDPersistable
    
    @Published private (set) var disneyCharacters: [DisneyCharacter] = []
    let cache: Cacheable
    private var disneyAPIResponseInfo: DisneyAPIResponseInfo?
    
    private var nextPageURL: String? = " "
    
    
    init(apiDataFetcher: DataFetchable = DIContainer.shared.resolve(type: DataFetchable.self), cache: Cacheable = DIContainer.shared.resolve(type: Cacheable.self), persistance: DisneyCDPersistable = DIContainer.shared.resolve(type: DisneyCDPersistable.self)) {
        self.apiDataFetcher = apiDataFetcher
        self.persistance = persistance
        self.cache = cache
    }
    
    func getDisneyCharacters() async throws {
        
        
        
//        guard disneyAPIResponseInfo?.nextPage == nextPageURL else {
//            throw CharactersRepositoryError.apiUrlErrror
//        }
//
        do {
            guard let disneyAPIResponse = try await fetchDisneyAPIResponse() else {
                throw APIError.NetworkFailure(response: nil, data: nil)
            }
            
            disneyCharacters.append(contentsOf: disneyAPIResponse.charactersData)
            disneyAPIResponseInfo = disneyAPIResponse.apiInfo
        } catch {
            throw error
        }
    }
    
    
    func saveFavorite(_ character: DisneyCharacter) async throws {
        try await persistance.saveDisneyCharacter(character)
    }
    
    func getSavedDisneyCharacters() async throws -> [DisneyCharacter] {
        try await persistance.retrieveAllDisneyCharacters()
    }
    
    func deleteDisneyCharacters(_ character: DisneyCharacter) async throws {
        
        guard let characterID = character.id else { return }
        try await persistance.deleteDisneyCharacter(using: characterID)
    }
    
    private func fetchDisneyAPIResponse() async throws -> DisneyAPIResponse? {
        nextPageURL = disneyAPIResponseInfo?.nextPage
        guard let url = nextPageURL == nil ? URL(string: AppConstants.baseURL) : URL(string: disneyAPIResponseInfo?.nextPage ?? "") else { return nil }
        
        let disneyAPIResponse: DisneyAPIResponse = try await apiDataFetcher.fetchData(url: url)
        
        return disneyAPIResponse
    }
    
    
    func getDisneyCharactersWithImages() async throws {
        var downloadedCharacters: [DisneyCharacter] = []
        
        try await getDisneyCharacters()
        
        let charactersWithImages = try await downloadImages(for: disneyCharacters)
        for characterWithImage in charactersWithImages {
            if let index = disneyCharacters.firstIndex(where: { $0.id == characterWithImage.id }) {
                disneyCharacters[index] = characterWithImage
                downloadedCharacters.append(characterWithImage)
            }
        }
        
        let updatedDisneyAPIResponse = DisneyAPIResponse(apiInfo: disneyAPIResponseInfo, charactersData: downloadedCharacters)
        cache.insert(updatedDisneyAPIResponse, forKey: AppConstants.cacheDisneyAPIResponseKey)
    }
    
    private func fetchCachedDisneyCharacters() -> DisneyAPIResponseInfo? {
        if let cachedAPIResponse = cache[AppConstants.cacheDisneyAPIResponseKey] as? DisneyAPIResponseInfo {
            return cachedAPIResponse
        }
        return nil
    }
    
    
    private func downloadImages(for disneyCharacters: [DisneyCharacter]) async throws -> [DisneyCharacter] {
        var charactersWithDownloadedImages: [DisneyCharacter] = []
        await withTaskGroup(of: DisneyCharacter.self) { group in
            for disneyCharacter in disneyCharacters {
                group.addTask {
                    var character = disneyCharacter
                    guard let stringURL = disneyCharacter.imageUrl, let url = URL(string: stringURL) else { return disneyCharacter }
                    
                    do {
                        let data: Data = try await self.apiDataFetcher.downloadData(from: url)
                        character.imageData = data
                        return character
                    } catch {
                        print("Failed to download image data: \(error)")
                        return character
                    }
                    
                }
            }
            
            for await character in group {
                charactersWithDownloadedImages.append(character)
            }
        }
        return charactersWithDownloadedImages
    }    
}
