//
//  PokeExplorerApp.swift
//  PokeExplorer
//
//  Created by Tiago Prestes on 09/06/25.
//

import SwiftUI
import SwiftData

@main
struct PokeExplorerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Usuario.self,
            Favorito.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @StateObject private var appInfo = AppInfo()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appInfo)
        }
        .modelContainer(sharedModelContainer)
    }
}
