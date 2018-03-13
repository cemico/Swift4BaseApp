//
//  NetworkSupportMockSync.swift
//  S4BA
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

class NetworkSupportMockSync: NetworkSupport {

    func handleRoute1(request: URLRequest, processingCompletionHandler: @escaping (Route1Model?) -> Void) {

        // common handler for any derived protocol classes
        doRoute1(request: request, processingCompletionHandler: processingCompletionHandler)
    }

    func handleRoute2(request: URLRequest, processingCompletionHandler: @escaping (Route2Model?) -> Void) {

        // common handler for any derived protocol classes
        doRoute2(request: request, processingCompletionHandler: processingCompletionHandler)
    }

    func doRoute1(request: URLRequest, processingCompletionHandler: @escaping (Route1Model?) -> Void) {

        // simulated response - move out into seperate file with perhaps path being environment variable
        let body: Attributes = [ "a" : "123",
                                 "b" : 123,
                                 "c" : "mama"  ]

        // serialize
        var data: Data?
        var error: Error?
        do {

            data = try JSONSerialization.data(withJSONObject: body, options: [])
        }
        catch(let err) {

            error = err
        }

        // use common handler
        handleRoute1Results(data: data, error: error, json: nil, resultsCompletionHandler: { (model: Route1Model?) in

            // pass results up
            processingCompletionHandler(model)
        })
    }

    func doRoute2(request: URLRequest, processingCompletionHandler: @escaping (Route2Model?) -> Void) {

        // simulated response
        let body: Attributes = [ "a" : "123",
                                 "b" : 123,
                                 "c" : "mama"  ]

        // serialize
        var data: Data?
        var error: Error?
        do {

            data = try JSONSerialization.data(withJSONObject: body, options: [])
        }
        catch(let err) {

            error = err
        }

        // use common handler
        handleRoute2Results(data: data, error: error, json: nil, resultsCompletionHandler: { (model: Route2Model?) in

            // pass results up
            processingCompletionHandler(model)
        })
    }
}
