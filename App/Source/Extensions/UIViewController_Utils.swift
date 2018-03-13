//
//  UIViewController_Utils.swift
//  S4BA
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import UIKit

extension UIViewController {

    //
    // accessors
    //

    func appDelegate() -> AppDelegate {

        // convenience wrapper
        return ApplicationDelegate
    }

    //
    // Debug routines
    //

    class func printWindowHierarchy(_ vcTop: UIViewController? = nil, level: Int = 0, isLastVc: Bool = false) {

        // note: if stopped in the debugger, can get a more comprehensive print using lldb's heirarchy command
        //       (lldb) expr -l objc++ -O -- [[[UIWindow keyWindow] rootViewController] _printHierarchy]
        //       search for 'state: appeared' to find out what is currently showing

        // vc could be vc or nav controller
        if let vc = (vcTop != nil ? vcTop : getRootViewController()) {

            if let nav = vc as? UINavigationController {

                // print nav
                let padding = " ".padding(toLength: max(0, level - 1), withPad: " ", startingAt: 0)
                printInfo("\(padding)\(nav.classForCoder)")

                // walk nav stack
                for vcNav in nav.viewControllers {

                    printWindowHierarchy(vcNav, level: level + 1, isLastVc: vcNav == nav.viewControllers.last)
                }
            }
            else {

                // print true vc
                let padding = " ".padding(toLength: level, withPad: " ", startingAt: 0)
                printInfo("\(padding)\(vc.classForCoder)")

                if isLastVc {

                    // check for any modal presented vc
                    if let vcPresented = vc.presentedViewController {

                        printWindowHierarchy(vcPresented, level: level + 1, isLastVc: isLastVc)
                    }
                }
            }
        }
    }

    class func getRootViewController() -> UIViewController? {

        // get root view controller
        if let vc = Application.keyWindow?.rootViewController {

            // current storyboard is setup with root as nav controller
            return vc
        }

        assertionFailure("no rootViewController set")
        return nil
    }
}

