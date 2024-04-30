//
//  DisneyCharacterDetailView.swift
//  DisneyDemoProject
//
//  Created by Ade Adegoke on 29/04/2024.
//

import SwiftUI

struct DisneyCharacterDetailView: View {
    
    @ObservedObject var viewModel: DisneyCharactersViewModel
    
    let disneyCharacter: DisneyCharacter
    @State private var isFavourite: Bool
    
    init(viewModel: DisneyCharactersViewModel, disneyCharacter: DisneyCharacter) {
        self.viewModel = viewModel
        self.disneyCharacter = disneyCharacter
        isFavourite = disneyCharacter.isFavourite ?? false
    }
        var body: some View {
        
        Button(action: {
            isFavourite.toggle()
        }) {
            Image(systemName: isFavourite ? "heart.fill" : "heart")
                .foregroundColor(isFavourite ? .red : .gray)
                .font(.system(size: 30))
                .padding()
        }
        
        List {
            if let imageURL = URL(string: disneyCharacter.imageUrl ?? "") {
                asyncImage(url: imageURL, placeholder: Image(systemName: "photo"))
                    .frame(width: 100, height: 100)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                Image(systemName: "photo")
                    .frame(width: 80, height: 80)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            if let disneyCharacterFilms = disneyCharacter.films, !disneyCharacterFilms.isEmpty {
                Section(header: Text("Films").font(.system(size: 25)).bold().foregroundColor(.black)) {
                    ForEach(disneyCharacterFilms, id: \.self) { film in
                        Text(film)
                    }
                }
            }
            
            if let disneyCharacterShortFilms = disneyCharacter.shortFilms, !disneyCharacterShortFilms.isEmpty {
                Section(header: Text("Short films").font(.system(size: 25)).bold().foregroundColor(.black)) {
                    ForEach(disneyCharacterShortFilms, id: \.self) { shortFilm in
                        Text(shortFilm)
                    }
                }
            }
            
        }
        .navigationTitle(disneyCharacter.name?.capitalized ?? "Disney Character")
        .onChange(of: isFavourite) { newValue in
            Task {
                 await viewModel.persist(newValue, character: disneyCharacter)
             }
        }
    }
}


    //struct DisneyCharacterDetailView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        DisneyCharacterDetailView()
    //    }
    //}
