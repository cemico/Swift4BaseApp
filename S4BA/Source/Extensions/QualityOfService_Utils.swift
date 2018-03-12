//
//  QualityOfService_Utils.swift
//  S4BA
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

extension QualityOfService: CustomStringConvertible {

    ///////////////////////////////////////////////////////////
    // local enums
    ///////////////////////////////////////////////////////////

    private enum qosDesc: String {

        case userInteractive, userInitiated, `default`, utility, background
    }

    ///////////////////////////////////////////////////////////
    // CustomStringConvertible
    ///////////////////////////////////////////////////////////

    public var description: String {

        switch self {

            case .userInteractive:
                return qosDesc.userInteractive.rawValue

            case .userInitiated:
                return qosDesc.userInitiated.rawValue

            case .default:
                return qosDesc.default.rawValue

            case .utility:
                return qosDesc.utility.rawValue

            case .background:
                return qosDesc.background.rawValue
        }
    }
}
