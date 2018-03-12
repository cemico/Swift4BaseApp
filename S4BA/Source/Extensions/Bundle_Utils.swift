//
//  Bundle_Utils.swift
//  S4BA
//
//  Created by Dave Rogers on 3/12/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

extension Bundle {

    ///////////////////////////////////////////////////////////
    // enums
    ///////////////////////////////////////////////////////////

    enum InfoItemTypes: String {

        case testApiKey = "TestAPIKey"
    }

    ///////////////////////////////////////////////////////////
    // class level properties
    ///////////////////////////////////////////////////////////

    // lookup key from info.plist's build-time population from build definitions
    // (which allows different keys for different build targets, say if
    //  you wanted a test key and prod key for debug and release)
    static var testApiKey: String {

        var keyValue = ""
        if let value = Bundle.main.stringInfoValue(for: .testApiKey) {

            keyValue = value
        }
        else {

            print("Check info.plist and user defined build constants for the definition of key: \(Bundle.InfoItemTypes.testApiKey.rawValue)")
        }

        return keyValue
    }

    ///////////////////////////////////////////////////////////
    // extended functions
    ///////////////////////////////////////////////////////////

    func stringInfoValue(for key: InfoItemTypes) -> String? {

        if let value: String = Bundle.main.infoValueOfType(for: key) {

            return value
        }

        return nil
    }

    // convience wrapper to extrat info.plist values
    func infoValueOfType<T>(for key: InfoItemTypes) -> T? {

        // unwrap info dict
        guard let infoDict = infoDictionary else { return nil }

        // unwrap type
        guard let value = infoDict[key.rawValue] as? T else { return nil }

        return value
    }
}
