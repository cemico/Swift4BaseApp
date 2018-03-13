//
//  String_Utils.swift
//  S4BA
//
//  Created by Dave Rogers on 3/4/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

extension String {

    ///////////////////////////////////////////////////////////
    // static / class
    ///////////////////////////////////////////////////////////

    static func className<T>(ofSelf: T) -> String {

        return String(describing: type(of: ofSelf))
    }

    static func from(any: Any, default value: String = "") -> String {

        return any as? String ?? value
    }

    ///////////////////////////////////////////////////////////
    // instance level
    ///////////////////////////////////////////////////////////

    var ext: String {

        let nsSelf = self as NSString
        return nsSelf.pathExtension
    }

    func stringByAppendingPathComponent(path: String) -> String {

        let nsSelf = self as NSString
        return nsSelf.appendingPathComponent(path)
    }

}

