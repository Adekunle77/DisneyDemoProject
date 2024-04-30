//
//  ShortFilmEntity+CoreDataProperties.swift
//  DisneyDemoProject
//
//  Created by Ade Adegoke on 28/04/2024.
//
//

import Foundation
import CoreData


extension ShortFilmEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShortFilmEntity> {
        return NSFetchRequest<ShortFilmEntity>(entityName: "ShortFilmEntity")
    }

    @NSManaged public var shortFilms: String?
    @NSManaged public var disneyCharacter: DisneyCharacterEntity?

}

extension ShortFilmEntity : Identifiable {

}
