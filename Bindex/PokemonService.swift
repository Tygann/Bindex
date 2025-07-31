import Foundation

struct APISet: Decodable {
    let id: String
    let name: String
    let series: String
    let releaseDate: String
}

struct APISetResponse: Decodable {
    let data: [APISet]
}

struct APICard: Decodable {
    let id: String
    let name: String
    let images: Images
    let set: SetInfo

    struct Images: Decodable {
        let small: String
    }

    struct SetInfo: Decodable {
        let id: String
    }
}

struct APICardResponse: Decodable {
    let data: [APICard]
}

final class PokemonService {
    private let baseURL = URL(string: "https://api.pokemontcg.io/v2")!

    func fetchSets() async throws -> [APISet] {
        let url = baseURL.appendingPathComponent("sets")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(APISetResponse.self, from: data).data
    }

    func fetchCards(for setID: String) async throws -> [APICard] {
        var components = URLComponents(url: baseURL.appendingPathComponent("cards"), resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "q", value: "set.id:\(setID)")]
        let (data, _) = try await URLSession.shared.data(from: components.url!)
        return try JSONDecoder().decode(APICardResponse.self, from: data).data
    }
}
