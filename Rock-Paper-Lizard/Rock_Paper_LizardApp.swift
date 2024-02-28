//
//  Rock_Paper_LizardApp.swift
//  Rock-Paper-Lizard
//
//  Created by Vikram on 09/02/2024.
//

import SwiftUI

@main
struct Rock_Paper_LizardApp: App {
    @StateObject var gameModel = GameModel()

    var body: some Scene {
        WindowGroup(id: "startView") {
            StartView()
                .environmentObject(gameModel)
        }

        ImmersiveSpace(id: "gameSpace") {
            GameViewSpace()
                .environmentObject(gameModel)
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}
