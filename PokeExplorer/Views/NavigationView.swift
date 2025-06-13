//
//  NavigationView.swift
//  PokeExplorer
//
//  Created by Tiago Prestes on 13/06/25.
//

enum TabsSelection {
    case favorites
    case search
}

import SwiftUI

struct NavigationView: View {
    
    @State private var selection: TabsSelection = .search
    
    var body: some View {
        TabView(selection: $selection) {
            Tab("Search", systemImage: "magnifyingglass", value: .search) {
                SearchView()
            }
            Tab("Favorites", systemImage: "heart.fill", value: .favorites) {
                FavoritesView()
            }
        }
    }
}

#Preview {
    NavigationView()
}
