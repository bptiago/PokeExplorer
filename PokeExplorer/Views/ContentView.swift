//
//  ContentView.swift
//  PokeExplorer
//
//  Created by Tiago Prestes on 09/06/25.
//

import SwiftUI
import SwiftData

enum AppState {
    case inicio
    case navegacao
}

import SwiftUI

struct ContentView: View {
    @State private var appState: AppState = .inicio
        
    var body: some View {
        switch appState {
        case .inicio:
            StartupView(appState: $appState)
        case .navegacao:
            NavigationView()
        }
    }
}

#Preview {
    ContentView()
}
