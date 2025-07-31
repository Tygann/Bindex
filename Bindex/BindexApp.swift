//
//  BindexApp.swift
//  Bindex
//
//  Created by Tyler Keegan on 2/20/25.
//

import SwiftUI
import SwiftData

@main
struct BindexApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            PokemonSet.self,
            PokemonCard.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
