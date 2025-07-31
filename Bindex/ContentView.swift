import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    private let service = PokemonService()

    @Query(sort: \PokemonSet.releaseDate, order: .reverse) private var sets: [PokemonSet]

    var body: some View {
        NavigationStack {
            List {
                ForEach(sets) { set in
                    NavigationLink(destination: CardListView(set: set)) {
                        VStack(alignment: .leading) {
                            Text(set.name)
                            Text(set.series).font(.caption)
                        }
                    }
                }
                .onDelete(perform: deleteSets)
            }
            .navigationTitle("Sets")
            .task {
                if sets.isEmpty {
                    await refresh()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Refresh") {
                        Task { await refresh() }
                    }
                }
            }
        }
    }

    private func refresh() async {
        do {
            let fetched = try await service.fetchSets()
            try await MainActor.run {
                sync(sets: fetched)
            }
        } catch {
            print("Failed to fetch sets: \(error)")
        }
    }

    private func sync(sets apiSets: [APISet]) {
        let existing = Dictionary(uniqueKeysWithValues: sets.map { ($0.id, $0) })
        var idsToKeep: Set<String> = []
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"

        for api in apiSets {
            idsToKeep.insert(api.id)
            let date = formatter.date(from: api.releaseDate) ?? Date()
            if let set = existing[api.id] {
                set.name = api.name
                set.series = api.series
                set.releaseDate = date
            } else {
                let newSet = PokemonSet(id: api.id,
                                        name: api.name,
                                        series: api.series,
                                        releaseDate: date)
                modelContext.insert(newSet)
            }
        }

        for set in sets where !idsToKeep.contains(set.id) {
            modelContext.delete(set)
        }
    }

    private func deleteSets(at offsets: IndexSet) {
        withAnimation {
            for set in offsets.map({ sets[$0] }) {
                modelContext.delete(set)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [PokemonSet.self, PokemonCard.self], inMemory: true)
}
