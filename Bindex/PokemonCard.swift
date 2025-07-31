import Foundation
import SwiftData

@Model
final class PokemonCard {
    @Attribute(.unique) var id: String
    var name: String
    var imageURL: URL?
    @Relationship var set: PokemonSet?

    init(id: String, name: String, imageURL: URL?, set: PokemonSet?) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.set = set
    }
}
