//
//  Bool_Utils.swift
//  S4BA
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

extension Bool {

    ///////////////////////////////////////////////////////////
    // static / class
    ///////////////////////////////////////////////////////////

    static func from(any: Any, default value: Bool = false) -> Bool {

        return any as? Bool ?? value
    }
}

