//
//  URLSession_Utils.swift
//  S4BA
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation
import UIKit

extension URLSession {

    enum URLSessionErrors: Error {

        case noData(reason: String)
    }

    static func dataRequest(request: URLRequest, completionHandler: @escaping ((_ data: Data?, _ error: Error?) -> Void)) {

        // mask off response handling
        URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in

            guard let error = error else {

                if let data = data {

                    // success
                    completionHandler(data, nil)
                }
                else {

                    completionHandler(nil, URLSessionErrors.noData(reason: "No Data"))
                }
                return
            }

            // error from URLSession
            return completionHandler(nil, error)

        }).resume()
    }
}


