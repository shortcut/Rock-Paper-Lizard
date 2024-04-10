//
//  Highscore.swift
//  Rock-Paper-Lizard
//
//  Created by Magnus Tviberg on 25/03/2024.
//

import Foundation
import SwiftData

@Model
class Highscore {
    @Attribute(.unique) var date: Date
    var score: Int
    var mode: GameMode

    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY, HH:mm"
        return dateFormatter.string(from: date)
    }

    init(date: Date, score: Int, mode: GameMode = .suddenDeath) {
        self.date = date
        self.score = score
        self.mode = mode
    }
}
