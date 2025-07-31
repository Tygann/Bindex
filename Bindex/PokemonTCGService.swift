import Foundation

class PokemonTCGService {
    static let shared = PokemonTCGService()
    private let baseURL = URL(string: "https://api.pokemontcg.io/v2")!

    private init() {}

    func fetchSets() async throws -> [PokemonSet] {
        let url = baseURL.appendingPathComponent("sets")
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(SetResponse.self, from: data)
        return response.data
    }

    func fetchCards(for setID: String) async throws -> [PokemonCard] {
        var components = URLComponents(url: baseURL.appendingPathComponent("cards"), resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "set.id", value: setID)]
        let (data, _) = try await URLSession.shared.data(from: components.url!)
        let response = try JSONDecoder().decode(CardResponse.self, from: data)
        return response.data
    }
}

private struct SetResponse: Codable {
    let data: [PokemonSet]
}

private struct CardResponse: Codable {
    let data: [PokemonCard]
}
