import Foundation

struct PokemonCard: Identifiable, Codable {
    let id: String
    let name: String
    let number: String
    let images: CardImages

    struct CardImages: Codable {
        let small: String
        let large: String
    }
}
