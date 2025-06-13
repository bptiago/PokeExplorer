//
//  AppState.swift
//  PokeExplorer
//
//  Created by Tiago Prestes on 13/06/25.
//

import Foundation

enum AppState {
    case inicio
    case navegacao
}

class AppInfo: ObservableObject {
    @Published var loggedUser: Usuario? = nil
    @Published var appState: AppState = .inicio
}
