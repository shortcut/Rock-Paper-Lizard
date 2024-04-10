//
//  PlayerCard.swift
//  Rock-Paper-Lizard
//
//  Created by Magnus Tviberg on 14/03/2024.
//

import SwiftUI

struct PlayerCard: View {
    let title: String
    @Binding var handFormation: HandFormation?
    @Binding var score: Int
    var body: some View {
        VStack(spacing: 16) {
            Text(title)
            if let handFormation {
                Text(handFormation.handEmoji)
                    .font(.system(size: 68))
            }
            Text("Poengsum: \(score)")
        }
        .padding(64)
    }
}

#Preview {
    PlayerCard(title: "You", handFormation: Binding(.constant(.scissors)), score: Binding(projectedValue: .constant(1)))
}
