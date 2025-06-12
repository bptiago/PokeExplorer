//
//  PokemonDetails.swift
//  PokeExplorer
//
//  Created by Tiago Prestes on 10/06/25.
//

import Foundation

struct PokemonSprites: Decodable {
    let back_default: String?
    let back_female: String?
    let back_shiny: String?
    let back_shiny_female: String?
    let front_default: String?
    let front_female: String?
    let front_shiny: String?
    let front_shiny_female: String?
    
}

struct PokemonTypeItem: Decodable {
    let name: String
    let url: String
}

struct PokemonType: Decodable {
    let slot: Int
    let type: PokemonTypeItem
}

struct PokemonMoveItem: Decodable {
    let name: String
    let url: String
}

struct PokemonMove: Decodable {
    let move: PokemonMoveItem
}

struct PokemonAbilityItem: Decodable {
    let name: String
    let url: String
}

struct PokemonAbility: Decodable {
    let is_hidden: Bool
    let slot: Int
    let ability: PokemonAbilityItem
}

struct PokemonResponse: Identifiable, Decodable {
    let id: Int
    let name: String
    let base_experience: Int
    let height: Int
    let order: Int
    let weight: Int
    let sprites: PokemonSprites
    let types: [PokemonType]
    let moves: [PokemonMove]
    let abilities: [PokemonAbility]
}
