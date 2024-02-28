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

struct StartView: View {
    @EnvironmentObject var gameModel: GameModel

    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    var body: some View {
        VStack {
            if gameModel.isPlaying {
                Group {
                    switch gameModel.handFormation {
                    case .rock:
                        Text("👊")
                    case .paper:
                        Text("🤚")
                    case .scissors:
                        Text("🖖")
                    case .none:
                        Text("Unknown")
                    }
                }
                .font(.largeTitle)

                if let handFormation = gameModel.handFormation {
                    Text(handFormation.rawValue)
                        .font(.title)
                }
            }

            Button {
                gameModel.isPlaying.toggle()
            } label: {
                Text(gameModel.isPlaying ? "End game" : "Start game")
            }
        }
        .onChange(of: gameModel.isPlaying) { oldValue, newValue in
            Task {
                if oldValue {
                    await dismissImmersiveSpace()
                } else {
                    await openImmersiveSpace(id: "gameSpace")
                }
            }
        }
    }
}

#Preview {
    StartView()
}
