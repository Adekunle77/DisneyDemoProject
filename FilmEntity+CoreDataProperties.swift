//
//  FilmEntity+CoreDataProperties.swift
//  DisneyDemoProject
//
//  Created by Ade Adegoke on 27/04/2024.
//
//

import Foundation
import CoreData


extension FilmEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FilmEntity> {
        return NSFetchRequest<FilmEntity>(entityName: "FilmEntity")
    }

    @NSManaged public var films: String?
    @NSManaged public var disneyCharacter: DisneyCharacterEntity?

}

extension FilmEntity : Identifiable {

}
