//
//  GameModel.swift
//  Rock-Paper-Lizard
//
//  Created by Toni Sucic on 28/02/2024.
//

import Foundation

enum HandFormation: String {
    case rock
    case paper
    case scissors
}

class GameModel: ObservableObject {
    @Published var isPlaying = false
    @Published var handFormation: HandFormation?
}
