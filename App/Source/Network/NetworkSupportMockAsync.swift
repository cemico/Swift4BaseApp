//
//  NetworkSupportMockAsync.swift
//  S4BA
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

class NetworkSupportMockAsync: NetworkSupportMockSync {
    
    override func handleRoute1(request: URLRequest, processingCompletionHandler: @escaping (Route1Model?) -> Void) {

        Concurrency.backgroundAsync { [weak self] in

            // call common handler since protocol derived classes don't play well with super
            self?.doRoute1(request: request, processingCompletionHandler: processingCompletionHandler)
        }
    }

    override func handleRoute2(request: URLRequest, processingCompletionHandler: @escaping (Route2Model?) -> Void) {

        super.handleRoute2(request: request, processingCompletionHandler: processingCompletionHandler)
        Concurrency.backgroundAsync { [weak self] in

            // call common handler since protocol derived classes don't play well with super
            self?.doRoute2(request: request, processingCompletionHandler: processingCompletionHandler)
        }
    }
}
