import Foundation

struct PokemonSet: Identifiable, Codable {
    let id: String
    let name: String
    let images: SetImages

    struct SetImages: Codable {
        let symbol: String
        let logo: String
    }
}
