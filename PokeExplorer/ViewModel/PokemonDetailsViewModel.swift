//
//  PokemonDetailsViewModel.swift
//  PokeExplorer
//
//  Created by Tiago Prestes on 10/06/25.
//

import Foundation
import SwiftData
import SwiftUI

class PokemonDetailsViewModel: ObservableObject {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var favorites: [Favorito]
    
    @Published var pokemon: PokemonResponse?
    
    func isPokemonFavorite(with id: Int) -> Bool {
        let descriptor = FetchDescriptor<Favorito>(predicate: #Predicate { $0.id == id })
        let entity = try? modelContext.fetch(descriptor).first
        return entity != nil ? true : false
    }
    
    func savePokemon(pokemon: PokemonResponse) {
        let favorite = Favorito(id: pokemon.id, name: pokemon.name)
        modelContext.insert(favorite)
    }
    
    func removeSavedPokemon(_ id: Int) {
        guard let favorite = favorites.filter({ $0.id == id }).first else {
            return
        }
        modelContext.delete(favorite)
    }
    
    func fetchPokemon(_ endpoint: String) async {
        guard let url = URL(string: endpoint) else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(PokemonResponse.self, from: data)
            self.pokemon = response
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
