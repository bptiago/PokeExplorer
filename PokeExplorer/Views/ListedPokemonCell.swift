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
            Image("placeholder")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.bottom, 10)
            
            Text(pokemon.name.capitalized)
                .font(.body.bold())
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(1)
            
            Text(pokemon.name.capitalized)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }
}
