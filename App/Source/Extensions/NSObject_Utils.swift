//
//  NSObject_Utils.swift
//  S4BA
//
//  Created by Dave Rogers on 3/4/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

extension NSObject {

    public var className: String {

        return type(of: self).className
    }

    public static var className: String {

        return String(describing: self)
    }
}
