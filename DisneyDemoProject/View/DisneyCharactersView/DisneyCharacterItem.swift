//
//  DisneyCharacterItem.swift
//  DisneyDemoProject
//
//  Created by Ade Adegoke on 29/04/2024.
//

import SwiftUI

struct DisneyCharacterItem: View {
    
    let disneyCharacter: DisneyCharacter
    
    var body: some View {
        HStack {
         
            if let imageURL = URL(string: disneyCharacter.imageUrl ?? "") {
                asyncImage(url: imageURL, placeholder: Image(systemName: "photo"))
                    .frame(width: 100, height: 100)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                Image(systemName: "photo")
                    .frame(width: 80, height: 80)
                    .frame(maxWidth: .infinity, alignment: .center)
            }

            Text(disneyCharacter.name?.capitalized ?? "Not available")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
        }

    }
}

