//
//  FavoritesView.swift
//  PokeExplorer
//
//  Created by Tiago Prestes on 13/06/25.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var appInfo: AppInfo
    @Query private var favorites: [Favorito]
    
    let columns = [GridItem(.adaptive(minimum: 160), spacing: 18)]
    
    var body: some View {
        NavigationStack {
            VStack (alignment: .leading, spacing: 32) {
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("Hello, \(appInfo.loggedUser!.username.capitalized)!")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(appInfo.loggedUser!.email)
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .fontWeight(.light)
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.easeInOut) {
                            appInfo.logout()
                        }
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundStyle(.primary)
                            .font(.headline)
                            .offset(y: 8)
                    }
                }
                
                
                Text("Aqui você vai encontrar todos os Pokemons que você marcou como favorito!")
                    .font(.body)
                    .fontWeight(.light)
                    .foregroundStyle(.secondary)
                                
                Divider()
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    Text("Favoritos")
                        .font(.headline)
                        .fontWeight(.bold)
                        .kerning(1)
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(favorites, id: \.self.id) { favorite in
                                let pokemon = ListedPokemon(name: favorite.name, url: favorite.url)
                                NavigationLink(
                                    destination: PokemonDetailsView(url: pokemon.url)) {
                                        ListedPokemonCell(pokemon: pokemon)
                                    }
                            }
                        }
                    }
                    
                }
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    FavoritesView()
}
