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
    
    @Environment(\.dismiss) var dismiss
        
    var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .font(.body.bold())
                .foregroundStyle(MyColors.accent)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(.circle)
                .preferredColorScheme(.dark)
        }
    }
    
    var body: some View {
        VStack(spacing: MySpacings.big) {
            
            if let pokemon = viewModel.pokemon {
                
                Button {
                    isFavorite ? removeSavedPokemon(pokemon.id) : savePokemon(pokemon: pokemon)
                    isFavorite.toggle()
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(.red)
                }
                
                HStack(alignment: .center, spacing: 10) {
                    Text(pokemon.name.capitalized)
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .fontWeight(.heavy)
                        .foregroundStyle(MyColors.primary)
                    
                    Text("(#0\(pokemon.id))")
                        .font(.subheadline)
                        .foregroundStyle(MyColors.secondary)
                }
                
                AsyncImage(url: URL(string: pokemon.sprites.front_default ?? "placeholder")) { image in
                    image.resizable()
                        .scaledToFill()
                        .frame(maxHeight: 300)
                        .clipped()
                } placeholder: {
                    ProgressView()
                }
                
                HStack (alignment: .center) {
                    VStack (spacing: MySpacings.small) {
                        Text(String(format: "%.1f", Float(pokemon.weight / 10)) + "kg")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .lineSpacing(5)
                            .foregroundStyle(MyColors.primary)
                        
                        Text("Weight")
                            .textCase(.uppercase)
                            .foregroundStyle(MyColors.secondary)
                            .font(.body)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider().frame(height: 50)
                        .background(MyColors.primary)

                    VStack (spacing: MySpacings.small) {
                        Text(pokemon.types.first?.type.name.capitalized ?? "Unknown")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .lineSpacing(5)
                            .foregroundStyle(MyColors.primary)
                        
                        Text("Type")
                            .textCase(.uppercase)
                            .foregroundStyle(MyColors.secondary)
                            .font(.body)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    
                    
                    Divider().frame(height: 50)
                        .background(MyColors.primary)

                    VStack (spacing: MySpacings.small) {
                        Text(String(format: "%.2f", Float(pokemon.height) / 100) + "m")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .lineSpacing(5)
                            .foregroundStyle(MyColors.primary)
                        
                        Text("Height")
                            .textCase(.uppercase)
                            .foregroundStyle(MyColors.secondary)
                            .font(.body)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    
                }
                
                Divider()
                    .background(MyColors.primary)
                
                HStack(alignment: .top) {
                    Text("Moves")
                        .foregroundStyle(MyColors.secondary)
                        .frame(width: 100, alignment: .leading)
                    
                    Text(pokemon.moves.prefix(5).map {
                        $0.move.name.capitalized
                    }.joined(separator: ", ") + "...")
                    .lineLimit(2)
                    .foregroundStyle(MyColors.primary)
                    
                    Spacer()
                    
                }
                
                HStack(alignment: .top) {
                    Text("Abilities")
                        .foregroundStyle(MyColors.secondary)
                        .frame(width: 100, alignment: .leading)
                    
                    
                    Text(
                        pokemon.abilities.prefix(5).map { $0.ability.name.capitalized }.joined(separator: ", "))
                    .lineLimit(2)
                    .foregroundStyle(MyColors.primary)
                    
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
        .padding(.horizontal, MySpacings.big)
        
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: backButton)
        
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
