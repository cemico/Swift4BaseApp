//
//  NetworkSupportAlamoFire.swift
//  S4BA
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation
import Alamofire

///////////////////////////////////////////////////////////
// Alamofire implementation
///////////////////////////////////////////////////////////

class NetworkSupportAlamoFire: NetworkSupport {

    func handleRoute1(request: URLRequest, processingCompletionHandler: @escaping (Route1Model?) -> Void) {

        Alamofire.request(request).responseJSON { [weak self] (response: DataResponse) in

            // capture strong reference
            guard let strongSelf = self else { processingCompletionHandler(nil); return }

            // extract results
            let data = response.data
            let error = response.result.error
//            let json = response.result.value as? Attributes

            // use common handler
            strongSelf.handleRoute1Results(data: data, error: error, json: nil, resultsCompletionHandler: { (model: Route1Model?) in

                // pass results up
                processingCompletionHandler(model)
            })
        }
    }

    func handleRoute2(request: URLRequest, processingCompletionHandler: @escaping (Route2Model?) -> Void) {

        Alamofire.request(request).responseJSON { [weak self] (response: DataResponse) in

            // capture strong reference
            guard let strongSelf = self else { processingCompletionHandler(nil); return }

            // extract results
            let data = response.data
            let error = response.result.error
//            let json = response.result.value as? Attributes

            // use common handler
            strongSelf.handleRoute2Results(data: data, error: error, json: nil, resultsCompletionHandler: { (model: Route2Model?) in

                // pass results up
                processingCompletionHandler(model)
            })
        }
    }
}
