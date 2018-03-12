//
//  NetworkSupportProtocol.swift
//  S4BA
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

///////////////////////////////////////////////////////////
// error enums
///////////////////////////////////////////////////////////

enum ApiError: Error {

    case badOrEmptyData(reason: String)
    case badRequest(reason: String)
}

///////////////////////////////////////////////////////////
// define a protocol and inject the network support in
// to allow easier path for testing and network mocking
///////////////////////////////////////////////////////////

protocol NetworkSupport: class {

    //
    // required
    //

    func handleRoute1(request: URLRequest, processingCompletionHandler: @escaping (Route1Model?) -> Void)
    func handleRoute2(request: URLRequest, processingCompletionHandler: @escaping (Route2Model?) -> Void)

    //
    // optional (with default implementation via the extension)
    //

    func handleRoute1Results(data: Data?,
                             error: Error?,
                             json: Attributes?,
                             resultsCompletionHandler: @escaping (Route1Model?) -> Void)

    func handleRoute2Results(data: Data?,
                             error: Error?,
                             json: Attributes?,
                             resultsCompletionHandler: @escaping (Route2Model?) -> Void)
}

extension NetworkSupport {

    // default implementation
    func handleRoute1Results(data: Data?,
                             error: Error?,
                             json: Attributes?,
                             resultsCompletionHandler: @escaping (Route1Model?) -> Void) {

        var model: Route1Model? = nil
        defer {

            // all exit paths must call completion handler
            resultsCompletionHandler(model)
        }

        // validation - no error
        if let error = error {

            handleError(error: error)
            return
        }

        if let json = json {

            printInfo("json received: \(json)")
        }

        // use exising data or translated into error data
        var newData = data
        if let json = json {

            if let errorData = errorCheck(json: json) {

                newData = errorData
            }
        }

        // validation - data exists
        guard let data = newData else {

            let error = ApiError.badOrEmptyData(reason: "No data returned")
            handleError(error: error)
            return
        }

        // use swift 4's new json codable protocol for our conforming model classes
        do {

            // automatic full object model build up
            let decoder = JSONDecoder()
            model = try decoder.decode(Route1Model.self, from: data)
        }
        catch {

            handleError(error: error)
        }
    }

    func handleRoute2Results(data: Data?,
                             error: Error?,
                             json: Attributes?,
                             resultsCompletionHandler: @escaping (Route2Model?) -> Void) {

        var model: Route2Model? = nil
        defer {

            // all exit paths must call completion handler
            resultsCompletionHandler(model)
        }

        // validation - no error
        if let error = error {

            handleError(error: error)
            return
        }

        // use exising data or translated into error data
        var newData = data
        if let json = json {

            if let errorData = errorCheck(json: json) {

                newData = errorData
            }
        }

        // validation - data exists
        guard let data = newData else {

            let error = ApiError.badOrEmptyData(reason: "No data returned")
            handleError(error: error)
            return
        }

        // use swift 4's new json codable protocol for our conforming model classes
        do {

            // automatic full object model build up
            let decoder = JSONDecoder()
            model = try decoder.decode(Route2Model.self, from: data)
        }
        catch {

            handleError(error: error)
        }
    }

    private func errorCheck(json: Attributes) -> Data? {

        printInfo("json received: \(json)")

        // common check for error in returned json
        let errorKey   = Router.ServerKeys.error.rawValue
        let messageKey = Router.ServerKeys.message.rawValue
        if let errorDict = json[errorKey] as? Attributes,
            let msg = errorDict[messageKey] as? String  {

            // translate from dict of error dict to just dict of error string as this is what
            // the decoder is expecting....
            let newError = [ errorKey : msg ]
            if let newErrorData = try? JSONSerialization.data(withJSONObject: newError, options: []) {

                return newErrorData
            }
        }

        return nil
    }

    private func handleError(error: Error) {

        printInfo("\(error)")
    }
}

