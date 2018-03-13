//
//  NetworkSupportNative.swift
//  S4BA
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

///////////////////////////////////////////////////////////
// native iOS implementation
///////////////////////////////////////////////////////////

class NetworkSupportNative: NetworkSupport {

    func handleRoute1(request: URLRequest, processingCompletionHandler: @escaping (Route1Model?) -> Void) {

        // wrap native iOS networking support
        URLSession.dataRequest(request: request) { [weak self] (data: Data?, error: Error?) in

            // capture strong reference
            guard let strongSelf = self else { processingCompletionHandler(nil); return }

            // use common handler
            strongSelf.handleRoute1Results(data: data, error: error, json: nil, resultsCompletionHandler: { (model: Route1Model?) in

                // pass results up
                processingCompletionHandler(model)
            })
        }
    }

    func handleRoute2(request: URLRequest, processingCompletionHandler: @escaping (Route2Model?) -> Void) {

        // wrap native iOS networking support
        URLSession.dataRequest(request: request) { [weak self] (data: Data?, error: Error?) in

            // capture strong reference
            guard let strongSelf = self else { processingCompletionHandler(nil); return }

            // use common handler
            strongSelf.handleRoute2Results(data: data, error: error, json: nil, resultsCompletionHandler: { (model: Route2Model?) in

                // pass results up
                processingCompletionHandler(model)
            })
        }
    }
}

