import Foundation
import SwiftData

@Model
final class PokemonSet {
    @Attribute(.unique) var id: String
    var name: String
    var series: String
    var releaseDate: Date
    @Relationship(deleteRule: .cascade, inverse: \PokemonCard.set) var cards: [PokemonCard]

    init(id: String, name: String, series: String, releaseDate: Date) {
        self.id = id
        self.name = name
        self.series = series
        self.releaseDate = releaseDate
        self.cards = []
    }
}
