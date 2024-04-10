//
//  CountDownView.swift
//  Rock-Paper-Lizard
//
//  Created by Eric Davis on 13/03/2024.
//

import SwiftUI

struct CountDownView: View {

    @Binding var value: Int

    init(value: Binding<Int>) {
        self._value = value
    }

    var body: some View {
        Text(value, format: .number)
            .font(.extraLargeTitle)
            .contentTransition(.numericText())
    }
}

#Preview {
    CountDownView(value: .constant(3))
}
