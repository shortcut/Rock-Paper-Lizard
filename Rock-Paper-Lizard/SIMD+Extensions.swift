//
//  SIMD+Extensions.swift
//  Rock-Paper-Lizard
//
//  Created by Toni Sucic on 28/02/2024.
//

import Foundation

extension SIMD4 {
    var xyz: SIMD3<Scalar> {
        self[SIMD3(0, 1, 2)]
    }
}
