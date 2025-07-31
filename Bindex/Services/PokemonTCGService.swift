import Foundation

struct PokemonTCGService {
    func fetchSets() async throws -> [PokemonSet] {
        let url = URL(string: "https://api.pokemontcg.io/v2/sets")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(PokemonSetResponse.self, from: data)
        return response.data
    }
}

private struct PokemonSetResponse: Decodable {
    let data: [PokemonSet]
}
