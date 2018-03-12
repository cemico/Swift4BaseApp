//
//  UserDefaults_Utils.swift
//  S4BA
//
//  Created by Dave Rogers on 3/4/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import UIKit

///////////////////////////////////////////////////////////
// utilize #function for naming
///////////////////////////////////////////////////////////

extension UserDefaults {

    ///////////////////////////////////////////////////////////
    // properties - computed
    ///////////////////////////////////////////////////////////

    var users: [String : String] {

        get {

            return self.dictionary(forKey: #function) as? [String : String] ?? [:]
        }

        set {

            self.set(newValue, forKey: #function)
            self.synchronize()
        }
    }

    var token: String {

        get {

            return self.string(forKey: #function) ?? ""
        }

        set {

            self.set(newValue, forKey: #function)
            self.synchronize()
        }
    }
}

