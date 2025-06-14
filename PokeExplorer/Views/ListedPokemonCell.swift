//
//  VerticalGridCellView.swift
//  ArteCuritiba
//
//  Created by Tiago Prestes on 20/05/25.
//

import SwiftUI

struct ListedPokemonCell: View {
    var pokemon: ListedPokemon
    
    var body: some View {
        VStack(alignment: .leading) {
            
            AsyncImage(url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemon.id).png")) { image in
                image.resizable()
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } placeholder: {
                ProgressView()
            }
            
            Text(pokemon.name.capitalized)
                .font(.body.bold())
                .foregroundColor(MyColors.primary)
                .multilineTextAlignment(.center)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }
}
