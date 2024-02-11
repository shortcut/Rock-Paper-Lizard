//
//  StartView.swift
//  Rock-Paper-Lizard
//
//  Created by Vikram on 09/02/2024.
//

import SwiftUI

struct StartView: View {
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Button {
                Task {
                    await openImmersiveSpace(id: "gameSpace")
                    dismiss()
                }
            } label: {
                Text("Start")
            }

        }
    }
}

#Preview {
    StartView()
}
