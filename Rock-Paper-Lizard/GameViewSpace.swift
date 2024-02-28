//
//  GameViewSpace.swift
//  Rock-Paper-Lizard
//
//  Created by Vikram on 09/02/2024.
//
import SwiftUI
import RealityKit
import RealityKitContent
import ARKit

struct GameViewSpace: View {
    private let session = ARKitSession()
    @EnvironmentObject var gameModel: GameModel

    var body: some View {
        Color.clear
            .task {
                let authStatuses = await session.requestAuthorization(for: [.handTracking])

                switch authStatuses[.handTracking] {
                case .allowed:
                    print("Hand tracking allowed")
                default:
                    return
                }

                let handTrackingProvider = HandTrackingProvider()

                do {
                    try await session.run([handTrackingProvider])
                } catch {
                    print(error)
                }

                for await anchorUpdate in handTrackingProvider.anchorUpdates where anchorUpdate.anchor.chirality == .right {
                    switch anchorUpdate.event {
                    case .added:
                        print("Added")

                    case .removed:
                        print("Removed")

                    case .updated:
                        print("Updated")

                        if let handSkeleton = anchorUpdate.anchor.handSkeleton {
                            gameModel.handFormation = handFormation(for: handSkeleton)
                        }
                    }
                }
            }
//            .task {
//                do {
//                    try await Task.sleep(for: .milliseconds(1000))
//                    gameModel.handFormation = .scissors
//                } catch {
//                    print(error)
//                }
//            }
    }

    func handFormation(for handSkeleton: HandSkeleton) -> HandFormation? {
        let indexFingerTipJoint = handSkeleton.joint(.indexFingerTip)
        let middleFingerTipJoint = handSkeleton.joint(.middleFingerTip)
        let ringFingerTipJoint = handSkeleton.joint(.ringFingerTip)
        let littleFingerTipJoint = handSkeleton.joint(.littleFingerTip)
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
        } else if indexFingerTipJointToWrist < 0.15,
                  middleFingerTipJoinToWrist < 0.15,
                  ringFingerTipToWrist < 0.15,
                  littleFingerTipToWrist < 0.15 {
            return .rock
        } else {
            return nil
        }
    }
}

#Preview(windowStyle: .automatic) {
    GameViewSpace()
}
