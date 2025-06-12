//
//  ListViewModel.swift
//  PokeExplorer
//
//  Created by Tiago Prestes on 10/06/25.
//

import Foundation

class ListViewModel: ObservableObject {
    @Published var pokemons: [ListedPokemon] = []
    @Published var searchText: String = ""
    
    // Função de filtrar por nome dps
    
    func getPokemons() async {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=8") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(ListedPokemonResponse.self, from: data)
            
            pokemons = response.results
            
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
