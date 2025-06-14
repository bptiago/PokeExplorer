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
            VStack (alignment: .leading, spacing: MySpacings.big) {
                    
                Text("PokeExplorer")
                    .font(.largeTitle.bold())
                    .foregroundStyle(MyColors.primary)
                
                Text("Procure por Pokémons e divirta-se! Quem sabe você não encontra seus favoritos?")
                    .font(.body)
                    .foregroundStyle(MyColors.secondary)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: MySpacings.medium) {
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
                            .foregroundStyle(MyColors.primary)
                            .background(MyColors.accent)
                            .clipShape(.buttonBorder)
                    }
                    .padding(.top, MySpacings.bigger)
                }
                .task {
                    await viewModel.getPokemons()
                }
            }
            .padding(.horizontal, MySpacings.big)
        }
    }
}

#Preview {
    SearchView()
}
