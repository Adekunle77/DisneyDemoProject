//
//  DisneyCharactersView.swift
//  DisneyDemoProject
//
//  Created by Ade Adegoke on 26/04/2024.
//

import SwiftUI

struct DisneyCharactersView: View {
    @StateObject private var viewModel = DisneyCharactersViewModel()
    @State private var isLoading = true
    @State var disneyCharactersOrder: CharactersOrder  = .alphabetical
    
    var body: some View {
  

        NavigationView {
            VStack {
                if isLoading {
                    Text("Loading\n Disney Characters")
                        .font(.system(size: 20, weight: .regular, design: .default))
                        .padding(.horizontal, 12)
                        .multilineTextAlignment(.center)
                        .lineSpacing(10)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        .frame(width: 100, height: 100)
                } else {
                
                if !viewModel.favouriteDisneyCharacters.isEmpty {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Favourite characters")
                            .font(.system(size: 15))
                            .bold()
                            .foregroundColor(.black)
                            .padding(.leading, 30)
                            .padding(.top, 20)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModel.favouriteDisneyCharacters.indices, id: \.self) { index in
                                    let disneyCharacter = viewModel.favouriteDisneyCharacters[index]
                                    NavigationLink(destination: DisneyCharacterDetailView(viewModel: viewModel, disneyCharacter: disneyCharacter)) {
                                        DisneyCharacterItem(disneyCharacter: disneyCharacter)
                                            .frame(width: 200)
                                            .padding(.leading, 30)
                                       
                                    }
                                }
                            }
                        }
                    }.frame(height: 100)
                }
                List(viewModel.disneyCharacters.indices, id: \.self) { index in
                    let disneyCharacter = viewModel.disneyCharacters[index]
                    NavigationLink {
                        DisneyCharacterDetailView(viewModel: viewModel, disneyCharacter: disneyCharacter)
                    } label: {
                        DisneyCharacterItem(disneyCharacter: disneyCharacter)
                            .frame(maxWidth: .infinity, maxHeight: 200, alignment: .leading)
                            
                    }.task {
                        if disneyCharacter == viewModel.disneyCharacters.last {
                            await viewModel.getDisneyCharacters()
                        }
                    }
                }
                .onDisappear {
                    Task {
                        try await viewModel.repository.getDisneyCharactersWithImages()
                    }
                }
                Spacer()
            }
        }
            .navigationTitle("Disney Characters")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Alphabetical", action: {
                            viewModel.sortCharacters(by: .alphabetical)
                        })
                        Button("Most films", action: {
                             viewModel.sortCharacters(by: .mostFilms)
                        })
                        Button("Most short films", action: {
                            viewModel.sortCharacters(by: .mostShortFilms)
                        })
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .alert(isPresented: $viewModel.showError.isError) {
                Alert(title: Text("Error"), message: Text(viewModel.showError.message), dismissButton: .default(Text("OK")))
                
            }
        }
        
        .navigationViewStyle(.stack)
        .task {
            await viewModel.getFavouriteDisneyCharacters()
            await viewModel.getDisneyCharacters()
            isLoading = false
        }
        .onChange(of: disneyCharactersOrder) {
            viewModel.sortCharacters(by: $0)
        }
   
    }
}

struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        DisneyCharactersView()
    }
}
