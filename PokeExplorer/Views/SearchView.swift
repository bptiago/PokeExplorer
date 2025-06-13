//
//  ListView.swift
//  PokeExplorer
//
//  Created by Tiago Prestes on 10/06/25.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [Favorito]
    
    @ObservedObject var viewModel = SearchViewModel()
    
    let columns = [GridItem(.adaptive(minimum: 160), spacing: 18)]
    
    var body: some View {
        NavigationStack {
            VStack (alignment: .leading, spacing: 24) {
                    
                Text("PokeExplorer")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.primary)
                
                Text("Procure por um Pokémon por meio de seu nome ou pelo seu número oficial na Pokédex.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                
                TextField("Buscar...", text: $viewModel.searchText)
                    .padding(12)
                    .background(Color(.tertiarySystemFill))
                    .cornerRadius(10)
                    .font(.body)
                    .clipShape(.buttonBorder)
            
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.pokemons, id: \.self.name) { pokemon in
                            NavigationLink(
                                destination: PokemonDetailsView(url: pokemon.url)) {
                                    ListedPokemonCell(pokemon: pokemon)
                                }
                        }
                    }
                    
                    // Botão de carregar mais
                }
                .task {
                    await viewModel.getPokemons()
                }
            }
            .padding()
            // Expandir a tela para que o usuário reconheça mais facilmente que há uma VGrid scrollabel
            .onAppear() {
                for i in favorites {
                    print(i.id)
                }
            }
        }
    }
}

#Preview {
    SearchView()
}
