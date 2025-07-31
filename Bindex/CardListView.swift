import SwiftUI
import SwiftData

struct CardListView: View {
    @Environment(\.modelContext) private var modelContext
    private let service = PokemonService()

    var set: PokemonSet
    @Query private var cards: [PokemonCard]

    init(set: PokemonSet) {
        self.set = set
        _cards = Query(filter: #Predicate { $0.set?.id == set.id }, sort: \PokemonCard.name)
    }

    var body: some View {
        List {
            ForEach(cards) { card in
                Text(card.name)
            }
            .onDelete(perform: deleteCards)
        }
        .navigationTitle(set.name)
        .task {
            if cards.isEmpty {
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

    private func refresh() async {
        do {
            let fetched = try await service.fetchCards(for: set.id)
            try await MainActor.run {
                sync(cards: fetched)
            }
        } catch {
            print("Failed to fetch cards: \(error)")
        }
    }

    private func sync(cards apiCards: [APICard]) {
        let existing = Dictionary(uniqueKeysWithValues: cards.map { ($0.id, $0) })
        var idsToKeep: Set<String> = []

        for api in apiCards {
            idsToKeep.insert(api.id)
            if let card = existing[api.id] {
                card.name = api.name
                card.imageURL = URL(string: api.images.small)
            } else {
                let newCard = PokemonCard(id: api.id,
                                          name: api.name,
                                          imageURL: URL(string: api.images.small),
                                          set: set)
                modelContext.insert(newCard)
            }
        }

        for card in cards where !idsToKeep.contains(card.id) {
            modelContext.delete(card)
        }
    }

    private func deleteCards(at offsets: IndexSet) {
        withAnimation {
            for card in offsets.map({ cards[$0] }) {
                modelContext.delete(card)
            }
        }
    }
}
