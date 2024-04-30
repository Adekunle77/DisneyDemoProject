//
//  DisneyCharacterHelper.swift
//  DisneyDemoProject
//
//  Created by Ade Adegoke on 28/04/2024.
//

import CoreData

struct DisneyCharacterHelper {
    static func createCharacterEntity(with character: DisneyCharacter?, using coreDataStack: ContextSavable) -> DisneyCharacterEntity? {
        var characterEntity: DisneyCharacterEntity? = nil

        coreDataStack.context.performAndWait {
            if let character = character {
                characterEntity = DisneyCharacterEntity(context: coreDataStack.persistentContainer.viewContext)
                
                characterEntity?.id = Int16(character.id ?? 0)
                
                if let films = character.films {
                    let filmEntities = films.map { filmTitle -> FilmEntity in
                        let filmEntity = FilmEntity(context: coreDataStack.context)
                        filmEntity.films = filmTitle
                        return filmEntity
                    }
                    characterEntity?.films = NSSet(array: filmEntities)
                }
                
                if let shortFilms = character.shortFilms {
                    let shortFilmEntities = shortFilms.map { shortFilmTitle -> ShortFilmEntity in
                        let shortFilmEntity = ShortFilmEntity(context: coreDataStack.context)
                        shortFilmEntity.shortFilms = shortFilmTitle
                        return shortFilmEntity
                    }
                    characterEntity?.shortFilms = NSSet(array: shortFilmEntities)
                }
                
                characterEntity?.sourceURL = character.sourceURL
                characterEntity?.name = character.name
                characterEntity?.imageURL = character.imageUrl
                characterEntity?.createdAt = character.createdAt
                characterEntity?.downloadedImageData = character.imageData
                characterEntity?.updatedAt = character.updatedAt
                characterEntity?.url = character.url
                characterEntity?.isFavourite = character.isFavourite ?? false 
                
            }
        }

        return characterEntity
    }

    
    static func createCharacter(with entity: DisneyCharacterEntity?) -> DisneyCharacter? {
        var films: [String] = []
        
        if let entity = entity {
            if let unwrappedFilms = entity.films {
                for film in unwrappedFilms {
                    if let film = film as? FilmEntity {
                        films.append(film.films ?? "")
                    }
                }
            }
            
            var shortFilms: [String] = []
            
            if let unwrappedShortFilms = entity.shortFilms {
                for shortFilm in unwrappedShortFilms {
                    if let shortFilm = shortFilm as? ShortFilmEntity {
                        shortFilms.append(shortFilm.shortFilms ?? "")
                    }
                }
            }
            
            let character = DisneyCharacter(
                id: Int(entity.id),
                films: films,
                shortFilms: shortFilms,
                sourceURL: entity.sourceURL,
                name: entity.name,
                imageUrl: entity.imageURL,
                createdAt: entity.createdAt,
                updatedAt: entity.updatedAt,
                url: entity.url,
                imageData: entity.downloadedImageData,
                isFavourite: entity.isFavourite
            )
            return character
        }
        
        return nil
    }
}
