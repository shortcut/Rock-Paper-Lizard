//
//  Rock_Paper_LizardApp.swift
//  Rock-Paper-Lizard
//
//  Created by Vikram on 09/02/2024.
//

import SwiftUI

@main
struct Rock_Paper_LizardApp: App {
    var body: some Scene {
        WindowGroup {
            StartView()
        }

        ImmersiveSpace(id: "gameSpace") {
            ContentView()
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}
