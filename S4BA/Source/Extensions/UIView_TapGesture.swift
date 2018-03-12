//
//  UIView_TapGesture.swift
//  S4BA
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import UIKit

//
// tap gesture support
//

extension UIView {

    // help with readability on our gesture closure
    typealias GestureAction = (() -> Void)?

    // extend UIView with our own custom property with runtime objc calls
    // note: in order to access, i.e. read/write, we need to define a key

    private struct Constants {

        // this is the core piece here for storage - it can be of
        // any type really, from UInt8 to String.  it is the physical
        // address used to extend the system class with a new property.
        // here I give it a string for readability, but could just as
        // easily be defined as:
        //
        // static var tapGestureRecognizer: UInt8 = 0
        //
        // one thing to note, as since this is the physical address being
        // used, in the calls to the objc runtime routines, you *must*
        // use this directly, versus something like this, which will NOT work:
        //
        // var key = Constants.tapGestureRecognizer
        // objc_getAssociatedObject(self, &key)
        //
        // and, finally, it's just an address, so you could also just as easily
        // provide the address outside a "struct", and just define a "var" for it:
        //
        // private var tapGestureRecognizerAddress: UInt8 = 0
        //

        // note: var type versus let because we're writing to this
        static var tapGestureRecognizer = "tapGestureRecognizer"
    }

    // internal computed property to access our new custom property
    private var tapGestureRecognizerAction: GestureAction? {

        get {

            // read, note: use struct address directly
            let tapGestureRecognizerClosure = objc_getAssociatedObject(self, &Constants.tapGestureRecognizer) as? GestureAction
            return tapGestureRecognizerClosure
        }

        set {

            if let newValue = newValue {

                // write with retain, note: use struct address directly
                objc_setAssociatedObject(self, &Constants.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
    }

    // public interface to associate a closure with a tap gesture on any view object
    func addTapGestureRecognizer(action: GestureAction) {

        // tap does no good if no user interaction
        self.isUserInteractionEnabled = true

        // save the closure in our custom private var
        self.tapGestureRecognizerAction = action

        // create a real tap gesture recognizer which we'll manage
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))

        // wire up the real tap gesture recognizer
        self.addGestureRecognizer(tapGestureRecognizer)
    }

    // Xcode 9 reduced auto objc declaratives, need to manually specify now
    @objc private func onTap(sender: UITapGestureRecognizer) {

        // retrieve our saved closure
        if let action = self.tapGestureRecognizerAction {

            // invoke
            action?()
        }
        else {

            printInfo("no closure for tap")
        }
    }
}

