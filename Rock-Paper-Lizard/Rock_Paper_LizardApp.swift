//
//  Rock_Paper_LizardApp.swift
//  Rock-Paper-Lizard
//
//  Created by Vikram on 09/02/2024.
//

import SwiftUI
import SwiftData

@main
struct Rock_Paper_LizardApp: App {
    @StateObject var gameModel = GameModel()

    let modelContainer: ModelContainer

    init() {
        do {
            modelContainer = try ModelContainer(for: Highscore.self)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }

    var body: some Scene {
        WindowGroup(id: "startView") {
            StartView()
                .environmentObject(gameModel)
                .frame(minWidth: 820, maxWidth: .infinity, minHeight: 750, maxHeight: .infinity)
        }
        .modelContainer(modelContainer)
        .windowResizability(.contentMinSize)

        ImmersiveSpace(id: "gameSpace") {
            GameViewSpace()
                .environmentObject(gameModel)
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}
