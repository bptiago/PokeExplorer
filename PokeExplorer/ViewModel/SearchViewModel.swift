//
//  ListViewModel.swift
//  PokeExplorer
//
//  Created by Tiago Prestes on 10/06/25.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var pokemons: [ListedPokemon] = []
    private var offset = 8
    private var limit = 8
    private(set) var hasLoaded = false
        
    func getPokemons() async {
        if hasLoaded { return }
        
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(ListedPokemonResponse.self, from: data)
            
            DispatchQueue.main.async {
                self.pokemons = response.results
                self.hasLoaded = true
            }
            
            
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func loadMorePokemons() async {
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
