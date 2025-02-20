//
//  Item.swift
//  Bindex
//
//  Created by Tyler Keegan on 2/20/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
