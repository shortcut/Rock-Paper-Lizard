//
//  CountDownView.swift
//  Rock-Paper-Lizard
//
//  Created by Eric Davis on 13/03/2024.
//

import SwiftUI

struct CountDownView: View {
    @State var countDownSeconds: Int
    @Binding var shouldStartCountdown: Bool
    @Binding var shouldStartGame: Bool

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        Text("\(countDownSeconds)")
            .font(.extraLargeTitle)
            .contentTransition(.numericText())
            .onReceive(timer)  { _ in
                if shouldStartCountdown {
                    if countDownSeconds > 0 {
                        withAnimation {
                            countDownSeconds -= 1
                        }
                    } else {
                        timer.upstream.connect().cancel()
                        shouldStartGame = true
                    }
                }
            }
    }
}

#Preview {
    CountDownView(countDownSeconds: 3,
                  shouldStartCountdown: .constant(true),
                  shouldStartGame: .constant(false))
}
