//
//  NetworkController.swift
//  S4BA
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import UIKit

class NetworkController {

    ///////////////////////////////////////////////////////////
    // data members
    ///////////////////////////////////////////////////////////

    // setup singleton
    static let shared = NetworkController()

    // networking library
    var network: NetworkSupport? {

        didSet {

            if let network = network {

                printInfo("\(String(describing: type(of: network))) configured\n   api: \(Router.baseURLString)\n   rtc: \(Router.baseRtcURLString)")
            }
        }
    }

    ///////////////////////////////////////////////////////////
    // lifecycle
    ///////////////////////////////////////////////////////////

    private init() {

        printInfo("\(String.className(ofSelf: self)).\(#function)")
    }
}

extension NetworkController {

    ///////////////////////////////////////////////////////////
    // api
    ///////////////////////////////////////////////////////////

    func getRoute1(completionHandler: @escaping (Route1Model?) -> Void) {

        // sanity check
        guard let network = network else { completionHandler(nil); return }

        // get request
        let route = Router.route1NoArgs
        guard let request = try? route.asURLRequest() else { completionHandler(nil); return }

        // hit server specific implementation
        network.handleRoute1(request: request, processingCompletionHandler: completionHandler)
    }

    func postRout2(token: String, completionHandler: @escaping (Route2Model?) -> Void) {

        // sanity check
        guard let network = network else { completionHandler(nil); return }

        // argument validation
        guard !token.isEmpty else { completionHandler(nil); return }

        // package up parameters
        let parameters: Attributes = [

            Router.DeviceKeys.deviceName.rawValue       : Device.name,
            Router.DeviceKeys.platform.rawValue         : Device.systemName,
            Router.DeviceKeys.platformVersion.rawValue  : Device.systemVersion,
            Router.ServerKeys.token.rawValue            : Settings.token
        ]
        printInfo("\(parameters)")

        // get request
        let route = Router.route2Args(parameters)
        guard let request = try? route.asURLRequest(with: token) else { completionHandler(nil); return }

        // hit server specific implementation
        network.handleRoute2(request: request, processingCompletionHandler: {(model: Route2Model?) in

            if model != nil {

                // save
                Settings.token = token
            }

            // pass along
            completionHandler(model)
        })
    }
}


