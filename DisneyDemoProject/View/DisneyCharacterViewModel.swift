//
//  DisneyCharactersViewModel.swift
//  DisneyDemoProject
//
//  Created by Ade Adegoke on 26/04/2024.
//

import Foundation
import Combine

enum CharactersOrder {
    case alphabetical
    case mostFilms
    case mostShortFilms
}

@MainActor
class DisneyCharactersViewModel: ObservableObject {
    
    let repository: CharactersRepositoryable
    @Published var showError: (isError: Bool, message: String) = (isError: false, message: "")
    @Published var disneyCharacters: [DisneyCharacter] = []
    @Published var favouriteDisneyCharacters: [DisneyCharacter] = []
    @Published var disneyCharactersOrder: CharactersOrder?
    
    init(repository: CharactersRepositoryable = DIContainer.shared.resolve(type: CharactersRepositoryable.self)) {
        self.repository = repository
    }
    
    func getDisneyCharacters() async {
        do {
            try await repository.getDisneyCharacters()
            disneyCharacters = repository.disneyCharacters
            sortCharacters(by: disneyCharactersOrder)
        } catch {
            showError = (isError: true, message: error.localizedDescription)
        }
    }
    
    func getFavouriteDisneyCharacters() async {
        do {
            let characters = try await repository.getSavedDisneyCharacters()
                self.favouriteDisneyCharacters = characters
        } catch {
            showError = (isError: true, message: error.localizedDescription)
        }
    }
    
    func persist(_ shouldSave: Bool, character: DisneyCharacter) async {
        do {
            var favouriteCharacter = character
            favouriteCharacter.isFavourite = true
            
            try await shouldSave ? repository.saveFavorite(favouriteCharacter) : repository.deleteDisneyCharacters(favouriteCharacter)
            await getFavouriteDisneyCharacters()
        } catch {
            showError = (isError: true, message: error.localizedDescription)
        }
    }
    
    func sortCharacters(by order: CharactersOrder? = nil) {
        disneyCharactersOrder = order
        switch order {
        case .alphabetical:
            DispatchQueue.main.async { [weak self] in
                self?.disneyCharacters.sort { $0.name ?? "" < $1.name ?? "" }
            }
        case .mostFilms:
            DispatchQueue.main.async { [weak self] in
                self?.disneyCharacters.sort { ($0.films?.count ?? 0) > ($1.films?.count ?? 0) }
            }
        case .mostShortFilms:
            DispatchQueue.main.async { [weak self] in
                self?.disneyCharacters.sort { ($0.shortFilms?.count ?? 0) > ($1.shortFilms?.count ?? 0) }
            }
        case .none:
            break
        }
    }

}
