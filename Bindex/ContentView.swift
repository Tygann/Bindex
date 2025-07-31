//
//  ContentView.swift
//  Bindex
//
//  Created by Tyler Keegan on 2/20/25.
//

import SwiftUI

struct ContentView: View {
    @State private var sets: [PokemonSet] = []

    var body: some View {
        NavigationSplitView {
            List(sets) { set in
                Text(set.name)
            }
            .task {
                await loadSets()
            }
        } detail: {
            Text("Select a set")
        }
    }

    private func loadSets() async {
        do {
            sets = try await PokemonTCGService().fetchSets()
        } catch {
            print("Failed to fetch sets: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
