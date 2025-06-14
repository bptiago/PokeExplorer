//
//  ListViewModel.swift
//  PokeExplorer
//
//  Created by Tiago Prestes on 10/06/25.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var pokemons: [ListedPokemon] = []
    private var offset = 0
    private var limit = 8
    
    // Função de filtrar por nome dps
    
    func getPokemons() async {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(ListedPokemonResponse.self, from: data)
            
            DispatchQueue.main.async {
                self.pokemons.append(contentsOf: response.results)
                self.offset += self.limit
            }
            
            
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
