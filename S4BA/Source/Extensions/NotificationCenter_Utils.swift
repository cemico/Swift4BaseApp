//
//  NotificationCenter_Utils.swift
//  S4BA
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import UIKit

// quick access
var Broadcast = NotificationCenter.default

typealias UserInfoDict = [AnyHashable : AnyHashable]

extension NotificationCenter {

    ///////////////////////////////////////////////////////////
    // instance level
    ///////////////////////////////////////////////////////////

    func postMT(name aName: NSNotification.Name, object anObject: Any? = nil, userInfo aUserInfo: UserInfoDict? = nil) {

        // must be run from main thread
        if Thread.current.isMainThread {

            self.post(name: aName, object: anObject, userInfo: aUserInfo)
        }
        else {

            DispatchQueue.main.async { [weak self] in

                self?.post(name: aName, object: anObject, userInfo: aUserInfo)
            }
        }
    }
}

