//
//  GameModel.swift
//  Rock-Paper-Lizard
//
//  Created by Toni Sucic on 28/02/2024.
//

import Foundation
import SwiftUI
import SwiftData

enum HandFormation: String, CaseIterable {
    case rock
    case paper
    case scissors

    var handEmoji: String {
        switch self {
        case .rock: "👊"
        case .paper: "🤚"
        case .scissors: "✌️"
        }
    }

    var emoji: String {
        switch  self {
        case .rock: "🪨"
        case .paper: "📃"
        case .scissors: "✂️"
        }
    }
}

enum GameState {
    case newGame
    case isPlaying
    case gameOver
}

enum GameTitle: String {
    case start = "Spillet er i gang"
    case won = "Du vant denne runden!"
    case lost = "Du tapte denne runden.."
    case draw = "Det ble uavgjort"
}

enum GameMode: Identifiable, CaseIterable, Codable {

    var id: Self {
        return self
    }

    case suddenDeath
    case freePlay

    var title: String {
        switch self {
        case .suddenDeath: "Sudden death"
        case .freePlay: "Fritt spill"
        }
    }

    var description: String {
        switch self {
        case .suddenDeath: "Taper du er spillet over"
        case .freePlay: "Spill helt til du blir lei"
        }
    }
}

class GameModel: ObservableObject {
    @Published var game: GameState = .newGame
    @Published var score: Int = 0
    @Published var opponentScore: Int = 0
    @Published var handFormation: HandFormation?
    @Published var yourChosenHandFormation: HandFormation?
    @Published var botHandFormation: HandFormation?
    @Published var title: GameTitle = .start
    @Published var gameMode: GameMode?

    @Published var secondsRemaining: Int = 3

    func startNewRound() {
        game = .isPlaying
        title = .start
        yourChosenHandFormation = nil
        botHandFormation = nil
        secondsRemaining = 3

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.secondsRemaining > 0 {
                withAnimation {
                    self.secondsRemaining -= 1
                }
            } else {
                timer.invalidate()
                self.decideResult()
            }
        }
    }

    func decideResult() {
        self.yourChosenHandFormation = self.handFormation
        self.botHandFormation = HandFormation.allCases.randomElement() ?? .rock
        if self.handFormation == .rock && self.botHandFormation == .scissors {
            self.won()
        } else if self.handFormation == .paper && self.botHandFormation == .rock {
            self.won()
        } else if self.handFormation == .scissors && self.botHandFormation == .paper {
            self.won()
        } else if self.handFormation == self.botHandFormation {
            self.draw()
        } else {
            self.lost()
        }
    }

    func won() {
        score += 1
        title = .won
    }

    func lost() {
        opponentScore += 1
        title = .lost
        if self.gameMode == .suddenDeath {
            self.endGame()
        }
    }

    func draw() {
        title = .draw
    }

    func endGame() {
        game = .gameOver
    }

    func goToStartScreen() {
        game = .newGame
    }

}
