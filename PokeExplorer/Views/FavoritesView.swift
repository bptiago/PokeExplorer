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
        VStack {
            Text("Hello, \(appInfo.loggedUser!.username)")
            
            NavigationStack {
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
                    
                    // Botão de carregar mais
                }
            }
        }
        
        
    }
}

#Preview {
    FavoritesView()
}
