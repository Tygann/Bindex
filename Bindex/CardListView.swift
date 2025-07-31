import SwiftUI

struct CardListView: View {
    let setID: String
    @State private var cards: [PokemonCard] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else if let errorMessage {
                VStack {
                    Text("Failed to load cards")
                    Text(errorMessage)
                        .font(.caption)
                }
            } else {
                List(cards) { card in
                    HStack(alignment: .top) {
                        AsyncImage(url: URL(string: card.images.small)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            Color.gray.opacity(0.3)
                        }
                        .frame(width: 60, height: 84)
                        VStack(alignment: .leading) {
                            Text(card.name)
                                .font(.headline)
                            Text("#\(card.number)")
                                .font(.subheadline)
                        }
                    }
                }
            }
        }
        .navigationTitle("Cards")
        .task {
            await loadCards()
        }
    }

    private func loadCards() async {
        isLoading = true
        do {
            cards = try await PokemonTCGService.shared.fetchCards(for: setID)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

#Preview {
    CardListView(setID: "base1")
}
