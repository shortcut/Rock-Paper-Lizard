//
//  StartView.swift
//  Rock-Paper-Lizard
//
//  Created by Vikram on 09/02/2024.
//

import SwiftUI
import RealityKit
import RealityKitContent
import ARKit
import SwiftData

struct StartView: View {
    @EnvironmentObject var gameModel: GameModel
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.modelContext) var modelContext

    @Query var scoreboard: [Highscore]

    var top10Scoreboard: [Highscore] {
        let sortedArray = scoreboard.sorted(by: { $0.score > $1.score })
        return Array(sortedArray.prefix(10))
    }

    var body: some View {
        VStack {
            switch gameModel.game {
            case .newGame:
                newGameView()
            case .isPlaying:
                playingView()
            case .gameOver:
                playingView()
            }
        }
        .ornament(attachmentAnchor: .scene(.top), contentAlignment: .center, ornament: {
            VStack {
                Text(gameModel.handFormation?.handEmoji ?? "Unknown")
                    .font(.system(size: 54))
            }
            .padding()
            .glassBackgroundEffect()
        })
        .onChange(of: gameModel.game) { oldValue, newValue in
            Task {
                guard oldValue != newValue else { return }
                switch newValue {
                case .isPlaying:
                    await openImmersiveSpace(id: "gameSpace")
                case .newGame:
                    await dismissImmersiveSpace()
                default:
                    return
                }
            }
        }
        .padding(68)
    }

    //MARK: -  Views for different game states

    @ViewBuilder
    private func newGameView() -> some View {
        VStack(spacing: 48) {
            Text("Stein, Saks, Papir!")
                .font(.extraLargeTitle)
            HStack(spacing: 32) {
                ForEach(GameMode.allCases) { gameMode in
                    gameModeButton(gameMode)
                }
            }
        }
        .padding()
        .ornament(visibility: .automatic, attachmentAnchor: .scene(.leading)) {
            if !top10Scoreboard.isEmpty {
                VStack(spacing: 32) {
                    Text("Topp 10 resulteter")
                        .font(.title)
                    VStack(spacing: 8) {
                        ForEach(top10Scoreboard) { highscore in
                            HStack {
                                Text(highscore.formattedDate)
                                Spacer()
                                Text("\(highscore.score)")
                            }
                        }
                    }
                }
                .padding(32)
                .glassBackgroundEffect()
            }
        }
    }

    @ViewBuilder
    private func playingView() -> some View {
        VStack(spacing: 16) {
            Spacer()
            if let gameMode = gameModel.gameMode {
                Text(gameMode.title)
                    .font(.title)
            }
            Text(gameModel.title.rawValue)
                .font(.extraLargeTitle2)
            CountDownView(value: $gameModel.secondsRemaining)
            HStack {
                PlayerCard(title: "Du valgte:", handFormation: $gameModel.yourChosenHandFormation, score: $gameModel.score)
                    .glassBackgroundEffect()
                PlayerCard(title: "Motstander valgte:", handFormation: $gameModel.botHandFormation, score: $gameModel.opponentScore)
                    .glassBackgroundEffect()
            }
            if gameModel.game == .isPlaying {
                Button("Start neste runde", action: gameModel.startNewRound)
            }
            Spacer()
            Button("Avslutt spillet") {
                if gameModel.game == .gameOver && gameModel.gameMode == .suddenDeath {
                    let highscore = Highscore(date: Date(), score: gameModel.score)
                    modelContext.insert(highscore)
                    try? modelContext.save()
                }
                gameModel.goToStartScreen()
            }
        }
        .padding()
    }

    @ViewBuilder
    private func gameOverView() -> some View {
        VStack(spacing: 16) {
            Text("Du tapte!")
                .font(.title)
            Text("Endelig poengsum: \(gameModel.score)")
            Button("Avslutt spillet"){
                let highscore = Highscore(date: Date(), score: gameModel.score)
                modelContext.insert(highscore)
                try? modelContext.save()
                gameModel.goToStartScreen()
            }
        }
    }

    // Button for game mode selection
    private func gameModeButton(_ gameMode: GameMode) -> some View {
        Button {
            gameModel.gameMode = gameMode
            gameModel.opponentScore = 0
            gameModel.score = 0
            gameModel.startNewRound()
        } label: {
            VStack(spacing: 16) {
                Text(gameMode.title)
                Text(gameMode.description)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .frame(minWidth: 150)
        }
    }
}

#Preview {
    StartView()
}
