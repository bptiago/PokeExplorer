//
//  PokemonDetailsView.swift
//  PokeExplorer
//
//  Created by Tiago Prestes on 10/06/25.
//

import SwiftUI
import SwiftData

struct PokemonDetailsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [Favorito]
    
    @StateObject var viewModel = PokemonDetailsViewModel()
    @State private var isFavorite = false
    
    var url: String
    
    var body: some View {
        VStack(spacing: 20) {
            
            if let pokemon = viewModel.pokemon {
                
                Button {
                    isFavorite ? removeSavedPokemon(pokemon.id) : savePokemon(pokemon: pokemon)
                    isFavorite.toggle()
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(.red)
                }
                
                VStack(spacing: 10) {
                    Text("#0\(pokemon.id)")
                        .font(.subheadline)
                    
                    Text(pokemon.name.capitalized)
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .fontWeight(.heavy)
                }
                .padding(.horizontal, 20)
                
                AsyncImage(url: URL(string: pokemon.sprites.front_default ?? "placeholder")) { image in
                    image.resizable()
                        .scaledToFill()
                        .frame(maxHeight: 300)
                        .clipped()
                } placeholder: {
                    ProgressView()
                }
                
                HStack (alignment: .center) {
                    VStack (spacing: 8) {
                        Text(String(format: "%.1f", Float(pokemon.weight / 10)) + "kg")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .lineSpacing(5)
                        
                        Text("Weight")
                            .textCase(.uppercase)
                            .foregroundStyle(.secondary)
                            .font(.body)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider().frame(height: 50)
                    
                    VStack (spacing: 8) {
                        Text(pokemon.types.first?.type.name.capitalized ?? "Unknown")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .lineSpacing(5)
                        
                        Text("Type")
                            .textCase(.uppercase)
                            .foregroundStyle(.secondary)
                            .font(.body)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    
                    
                    Divider().frame(height: 50)
                    
                    VStack (spacing: 8) {
                        Text(String(format: "%.2f", Float(pokemon.height) / 100) + "m")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .lineSpacing(5)
                        
                        Text("Height")
                            .textCase(.uppercase)
                            .foregroundStyle(.secondary)
                            .font(.body)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    
                }
                
                Divider()
                
                HStack(alignment: .top) {
                    Text("Moves")
                        .foregroundStyle(.secondary)
                        .frame(width: 100, alignment: .leading)
                    
                    Text(pokemon.moves.prefix(5).map {
                        $0.move.name.capitalized
                    }.joined(separator: ", ") + "...")
                    .lineLimit(2)
                    
                    Spacer()
                    
                }
                
                HStack(alignment: .top) {
                    Text("Abilities")
                        .foregroundStyle(.secondary)
                        .frame(width: 100, alignment: .leading)
                    
                    
                    Text(
                        pokemon.abilities.prefix(5).map { $0.ability.name.capitalized }.joined(separator: ", "))
                    .lineLimit(2)
                    
                    Spacer()
                }
            } else {
                ProgressView("Carregando Pokémon...")
            }
            
            Spacer()
        }
        .task {
            await viewModel.fetchPokemon(url)
        }
        
        .onChange(of: viewModel.pokemon, { _, newValue in
            if let newValue {
                isFavorite = isPokemonFavorite(with: newValue.id)
            }
        })
        
        .padding(.top, 16)
        .padding(.horizontal, 32)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
    
    func isPokemonFavorite(with id: Int) -> Bool {
        let descriptor = FetchDescriptor<Favorito>(predicate: #Predicate { $0.id == id })
        let entity = try? modelContext.fetch(descriptor).first
        return entity != nil ? true : false
    }
    
    func savePokemon(pokemon: PokemonResponse) {
        let favorite = Favorito(id: pokemon.id, name: pokemon.name, url: url)
        modelContext.insert(favorite)
    }
    
    func removeSavedPokemon(_ id: Int) {
        guard let favorite = favorites.filter({ $0.id == id }).first else {
            return
        }
        modelContext.delete(favorite)
    }
}

#Preview {
    PokemonDetailsView(url: "https://pokeapi.co/api/v2/pokemon/1/")
}
