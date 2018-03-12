//
//  NotificationName_Utils.swift
//  S4BA
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

extension Notification.Name {

    //
    // unique messages to post
    //

    private struct Messages {

        // good practice using reverse dns notation
        private static let baseMessage  = companyReverseDomain + "messages."

        struct system {

            static let prefix           = "system."
            static let changeLanguage   = baseMessage + system.prefix + "changeLanguage"
        }
    }

    //
    // keys to set and access posted data
    //

    struct Keys {

        struct Language {

            static let oldLanguageId    = "oldLanguageId"
            static let newLanguageId    = "newLanguageId"
        }
    }

    //
    // Language
    // note: usage in postMessage: .changeLanguage
    //

    static let changeLanguage           = Notification.Name(Messages.system.changeLanguage)
}

