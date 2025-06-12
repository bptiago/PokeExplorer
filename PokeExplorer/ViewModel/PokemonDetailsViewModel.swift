//
//  PokemonDetailsViewModel.swift
//  PokeExplorer
//
//  Created by Tiago Prestes on 10/06/25.
//

import Foundation
import SwiftData

class PokemonDetailsViewModel: ObservableObject {
    
    @Published var pokemon: PokemonResponse?
    
    func getPokemon(_ endpoint: String) async {
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
