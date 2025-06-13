//
//  ListedPokemon.swift
//  PokeExplorer
//
//  Created by Tiago Prestes on 10/06/25.
//

import Foundation

// Se colocar uma propriedade ID, o decoder falha
// ID precisaria ser uma variável computada de um dos outros campos
struct ListedPokemon: Decodable {
    let name: String
    let url: String
    
    var id: Int {
        let n = url.split(separator: "/").last!
        return Int(n)!
    }
}

struct ListedPokemonResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [ListedPokemon]
}
