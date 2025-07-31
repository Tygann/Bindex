import SwiftUI

struct ContentView: View {
    @State private var sets: [PokemonSet] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView()
                } else if let errorMessage {
                    VStack {
                        Text("Failed to load sets")
                        Text(errorMessage)
                            .font(.caption)
                    }
                } else {
                    List(sets) { set in
                        NavigationLink(destination: CardListView(setID: set.id)) {
                            HStack {
                                AsyncImage(url: URL(string: set.images.symbol)) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    Color.gray.opacity(0.3)
                                }
                                .frame(width: 40, height: 40)
                                Text(set.name)
                                    .font(.headline)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Sets")
        }
        .task {
            await loadSets()
        }
    }

    private func loadSets() async {
        isLoading = true
        do {
            sets = try await PokemonTCGService.shared.fetchSets()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

#Preview {
    ContentView()
}
