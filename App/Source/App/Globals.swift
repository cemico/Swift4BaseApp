//
//  Globals.swift
//  S4BA
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import UIKit

///////////////////////////////////////////////////////////
// quick accessors
///////////////////////////////////////////////////////////

var Application = UIApplication.shared
var ApplicationDelegate = (Application.delegate as! AppDelegate)
var Concurrency = QueueMgr.shared
var Feedback = HapticMgr.shared
var Settings = UserDefaults.standard
var Device = UIDevice.current
 var Network = NetworkController.shared

///////////////////////////////////////////////////////////
// global scope
///////////////////////////////////////////////////////////

let companyReverseDomain        = "com.cemico."
let companyDomain               = "cemico.com"
let modelObjectVersionPrecision = 2

func printOptional(_ string: String?, default: String = "nil") {

    if let string = string {

        print(string)
    }
    else {

        print(`default`)
    }
}

// wrapped to allow overriding
func printInfo(_ log: String) {

    print(log)
}

func printWarming(_ log: String) {

    print(log)
}

func printError(_ log: String) {

    print(log)
}
