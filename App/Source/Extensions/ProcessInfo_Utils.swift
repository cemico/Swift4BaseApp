//
//  ProcessInfo_Utils.swift
//  v
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

extension ProcessInfo {

    ///////////////////////////////////////////////////////////
    // environment strings
    ///////////////////////////////////////////////////////////

    enum NetworkSetting: String {

        case mockSync   = "APP_NETWORK_MOCK_SYNC"
        case mockAsync  = "APP_NETWORK_MOCK_ASYNC"
        case native     = "APP_NETWORK_NATIVE"

        // also when no setting exists
        case `default`  = "APP_NETWORK_DEFAULT"
    }

    ///////////////////////////////////////////////////////////
    // statics
    ///////////////////////////////////////////////////////////

    static func getEnvironment() -> NetworkSetting {

        if isEnvironment(env: NetworkSetting.mockSync.rawValue) {

            return .mockSync
        }
        else if isEnvironment(env: NetworkSetting.mockAsync.rawValue) {

            return .mockAsync
        }
        else if isEnvironment(env: NetworkSetting.native.rawValue) {

            return .native
        }

        return .default
    }

    static func isEnvironment(env: String) -> Bool {

        return (processInfo.environment[env] != nil)
    }

    static func iOSGTE(version: Int) -> Bool {

        return (processInfo.operatingSystemVersion.majorVersion >= version)
    }
}
