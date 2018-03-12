//
//  Float_Utils.swift
//  S4BA
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

extension Float {

    ///////////////////////////////////////////////////////////
    // static / class
    ///////////////////////////////////////////////////////////

    static func from(any: Any, default value: Float = 0) -> Float {

        return any as? Float ?? value
    }
}

