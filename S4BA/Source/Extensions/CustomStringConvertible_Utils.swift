//
//  CustomStringConvertible_Utils.swift
//  S4BA
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

//
// https://medium.com/@YogevSitton/use-auto-describing-objects-with-customstringconvertible-49528b55f446
//

extension CustomStringConvertible {

    ///////////////////////////////////////////////////////////
    // computed properties
    ///////////////////////////////////////////////////////////

    var description : String {

        // identify class
        var description = "Class: \(type(of: self))\n"

        // spin through all real properties (i.e. computed properties do not show up)
        var selfMirror: Mirror = Mirror(reflecting: self)
        while true {

            for child in selfMirror.children {

                if let propertyName = child.label {

                    description += "> \(propertyName): \(child.value)\n"
                }
            }

            // check base class
            if let sm = selfMirror.superclassMirror {

                selfMirror = sm
            }
            else {

                break
            }
        }

        return description
    }
}

