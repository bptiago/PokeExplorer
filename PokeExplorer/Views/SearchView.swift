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
            
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.pokemons, id: \.self.name) { pokemon in
                            NavigationLink(
                                destination: PokemonDetailsView(url: pokemon.url)) {
                                    ListedPokemonCell(pokemon: pokemon)
                                }
                        }
                    }
                    
                    Button {
                        Task {
                            await viewModel.getPokemons()
                        }
                    } label: {
                        Text("Carregar mais")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .background(Color.accentColor)
                            .clipShape(.buttonBorder)
                    }
                    .padding(.top, 24)
                
                }
                .task {
                    await viewModel.getPokemons()
                }
            }
            .padding(.horizontal, 24)
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
