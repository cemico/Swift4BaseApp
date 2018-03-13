//
//  HapticMgr.swift
//  S4BA
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

class HapticMgr {

    ///////////////////////////////////////////////////////////
    // enums
    ///////////////////////////////////////////////////////////

    enum HapticFeedbackLevels {

        case light, medium, heavy
    }

    enum HapticNotificationLevels {

        case success, warning, failure
    }

    enum HapticSelectionLevels {

        case tick
    }

    enum HapticTypes {

        case feedback(HapticFeedbackLevels)
        case notification(HapticNotificationLevels)
        case selection(HapticSelectionLevels)
    }

    ///////////////////////////////////////////////////////////
    // data members
    ///////////////////////////////////////////////////////////

    // setup singleton
    static let shared = HapticMgr()

    ///////////////////////////////////////////////////////////
    // lifecycle
    ///////////////////////////////////////////////////////////

    private init() {

        printInfo("\(String.className(ofSelf: self)).\(#function)")
    }

    ///////////////////////////////////////////////////////////
    // api - haptic
    ///////////////////////////////////////////////////////////

    func feedback(type: HapticTypes) {

        //
        // https://developer.apple.com/ios/human-interface-guidelines/interaction/feedback/
        //
        // 3 types:
        //  a) UIImpactFeedbackGenerator - 3 varients, success, warning, and failure
        //  b) UINotificationFeedbackGenerator - 3 varients, light, medium, heavy
        //  c) UISelectionFeedbackGenerator - 1 varient, as when user scrolls the picker wheel

        //        // example direct
        //        if #available(iOS 10.0, *) {
        //
        //            // iOS 10+ only
        //            let feedbackGenerator = UISelectionFeedbackGenerator()
        //            feedbackGenerator.selectionChanged()
        //        }

        //        // sample usage:
        //        HapticMgr.shared.feedback(type: .notification(.success))

        switch type {

            case .feedback(let level):

                switch level {

                    case .light:            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    case .medium:           UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    case .heavy:            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                }

            case .notification(let level):

                switch level {

                    case .success:          UINotificationFeedbackGenerator().notificationOccurred(.success)
                    case .warning:          UINotificationFeedbackGenerator().notificationOccurred(.warning)
                    case .failure:          UINotificationFeedbackGenerator().notificationOccurred(.error)
                }

            case .selection(let level):

                switch level {

                    case .tick:             UISelectionFeedbackGenerator().selectionChanged()
                }
            }
    }

    //
    // quick accessors
    //

    func feedbackHeavy() {

        feedback(type: .feedback(.heavy))
    }

    func notificationError() {

        feedback(type: .notification(.failure))
    }

    func vibrate() {

        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
}
