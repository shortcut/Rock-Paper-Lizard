//
//  ContentView.swift
//  Rock-Paper-Lizard
//
//  Created by Vikram on 09/02/2024.
//
import SwiftUI
import RealityKit
import RealityKitContent
import ARKit
import simd

enum HandFormation: String {
    case rock
    case paper
    case scissors
}

struct ContentView: View {
    @State private var handFormation = HandFormation.rock

    var body: some View {
        VStack {
            Group {
                switch handFormation {
                case .rock:
                    Text("👊")
                case .paper:
                    Text("🤚")
                case .scissors:
                    Text("🖖")
                }
            }
            .font(.largeTitle)

            Text(handFormation.rawValue)
                .font(.title)
        }
        .padding()
        .transform3DEffect(.init(translation: Vector3D(x: 0, y: 10, z: 10)))
        .task {
            let session = ARKitSession()
            //_ = await session.requestAuthorization(for: [.handTracking])

            let handTrackingProvider = HandTrackingProvider()
            do {
                try await session.run([handTrackingProvider])
            } catch {
                print(error)
            }

            for await anchorUpdate in handTrackingProvider.anchorUpdates where anchorUpdate.anchor.chirality == .right {
                switch anchorUpdate.event {
                case .added:
                    print("added")

                case .removed:
                    print("removed")

                case .updated:
                    print("updated")
                    if let handSkeleton = anchorUpdate.anchor.handSkeleton {
                        self.handFormation = handFormation(for: handSkeleton)
                        print(self.handFormation)

                        // handSkeleton.joint(.forearmArm)
                    }
                }
            }
        }


    }

    func handFormation(for handSkeleton: HandSkeleton) -> HandFormation {
        let thumbTipJoint = handSkeleton.joint(.thumbTip)
        let indexFingerTipJoint = handSkeleton.joint(.indexFingerTip)
        let middleFingerTipJoint = handSkeleton.joint(.middleFingerTip)
        let ringFingerTipJoint = handSkeleton.joint(.ringFingerTip)
        let littleFingerTipJoint = handSkeleton.joint(.littleFingerTip)

        let indexFingerMetacarpalJoint = handSkeleton.joint(.indexFingerMetacarpal)
        let middleFingerMetacarpalJoint = handSkeleton.joint(.middleFingerMetacarpal)
        let ringFingerMetacarpalJoint = handSkeleton.joint(.ringFingerMetacarpal)
        let littleFingerMetacarpalJoint = handSkeleton.joint(.littleFingerMetacarpal)

        let forearmWristJoint = handSkeleton.joint(.forearmWrist)

        let indexFingerTipJointToWrist = distance(indexFingerTipJoint.anchorFromJointTransform.columns.3.xyz,
                                                  forearmWristJoint.anchorFromJointTransform.columns.3.xyz)

        let middleFingerTipJoinToWrist = distance(middleFingerTipJoint.anchorFromJointTransform.columns.3.xyz,
                                                  forearmWristJoint.anchorFromJointTransform.columns.3.xyz)

        let ringFingerTipToWrist = distance(ringFingerTipJoint.anchorFromJointTransform.columns.3.xyz,
                                            forearmWristJoint.anchorFromJointTransform.columns.3.xyz)

        let littleFingerTipToWrist = distance(littleFingerTipJoint.anchorFromJointTransform.columns.3.xyz,
                                            forearmWristJoint.anchorFromJointTransform.columns.3.xyz)

        if indexFingerTipJointToWrist >= 0.15,
           middleFingerTipJoinToWrist >= 0.15,
           ringFingerTipToWrist >= 0.15,
           littleFingerTipToWrist >= 0.15 {
            return .paper
        } else if indexFingerTipJointToWrist >= 0.15,
                  middleFingerTipJoinToWrist >= 0.15,
                  ringFingerTipToWrist < 0.15,
                  littleFingerTipToWrist < 0.15 {
            return .scissors
        } else {
            return .rock
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}

extension SIMD4 {
    var xyz: SIMD3<Scalar> {
        self[SIMD3(0, 1, 2)]
    }
}
