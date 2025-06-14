//
//  ContentView.swift
//  PokeExplorer
//
//  Created by Tiago Prestes on 09/06/25.
//

import SwiftUI
import SwiftData
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appInfo: AppInfo
        
    var body: some View {
        switch appInfo.appState {
        case .inicio:
            StartupView()
        case .navegacao:
            NavigationView()
        }
    }
}

#Preview {
    ContentView()
}
