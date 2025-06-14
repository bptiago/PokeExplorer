//
//  FavoritesView.swift
//  PokeExplorer
//
//  Created by Tiago Prestes on 13/06/25.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var appInfo: AppInfo
    @Query private var favorites: [Favorito]
    
    let columns = [GridItem(.adaptive(minimum: 160), spacing: 18)]
    
    var body: some View {
        
        NavigationStack {
            VStack (alignment: .leading, spacing: MySpacings.bigger) {
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("Olá, \(appInfo.loggedUser!.username.capitalized)!")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(MyColors.primary)
                        
                        Text(appInfo.loggedUser!.email)
                            .font(.headline)
                            .foregroundStyle(MyColors.secondary)
                            .fontWeight(.light)
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.easeInOut) {
                            appInfo.logout()
                        }
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundStyle(MyColors.accent)
                            .font(.headline)
                            .offset(y: 8)
                    }
                }
                
                
                Text("Aqui você vai encontrar todos os Pokémons que você marcou como favorito!")
                    .font(.body)
                    .fontWeight(.light)
                    .foregroundStyle(MyColors.primary)
                
                Divider()
                    .background(MyColors.primary)
                
                VStack(alignment: .leading, spacing: MySpacings.medium) {
                    
                    Text("Favoritos")
                        .foregroundStyle(MyColors.primary)
                        .font(.headline)
                        .fontWeight(.bold)
                        .kerning(1)
                    
                    if favorites.isEmpty {
                        Text("Nenhum favorito ainda...")
                            .font(.subheadline)
                            .foregroundStyle(MyColors.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.top, MySpacings.medium)
                        
                        Spacer()
                    } else {
                        
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: MySpacings.medium) {
                                ForEach(favorites, id: \.self.id) { favorite in
                                    let pokemon = ListedPokemon(name: favorite.name, url: favorite.url)
                                    NavigationLink(
                                        destination: PokemonDetailsView(url: pokemon.url)) {
                                            ListedPokemonCell(pokemon: pokemon)
                                        }
                                }
                            }
                        }
                        
                    }
                }
            }
        }
        .padding(.horizontal, MySpacings.big)
    }
}

#Preview {
    FavoritesView()
}
