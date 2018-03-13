//
//  Router.swift
//  S4BA
//
//  Created by Dave Rogers on 3/6/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

// used for encoding routines
import Alamofire

///////////////////////////////////////////////////////////
// alias for ease of reading
///////////////////////////////////////////////////////////

public typealias Attributes = [String: Any]

///////////////////////////////////////////////////////////
// router definition
//
// decent article: https://grokswift.com/router/
//
///////////////////////////////////////////////////////////

enum Router {

    ///////////////////////////////////////////////////////////
    // router enums
    ///////////////////////////////////////////////////////////

    // each case can have various arguments if IDs and such need to be passed in
    case route1NoArgs

    // registers
    case route2Args(Attributes)
}

extension Router {

    ///////////////////////////////////////////////////////////
    // constants
    ///////////////////////////////////////////////////////////

    fileprivate struct Constants {

        struct Api {

            // schemes / protocols
            static let httpsScheme              = "https://"
            static let currentScheme            = Api.httpsScheme

            // canonical names / subdomains
            static let wwwCName                 = "www."
            static let apiCName                 = "api."
            static let rtcCName                 = "rtc."
            static let currentRtc               = Api.rtcCName
            static let currentApi               = Api.apiCName

            // hosts / domains - dev, int/staging, prod
            static let intHost                  = "int." + companyDomain
            static let devHost1                 = "dev." + companyDomain
            static let devHost                  = "localhost:3000"
            static let prodHost                 = companyDomain

            // versions
            static let vNone                    = ""
            static let v1                       = "/v1"
            static let currentVersion           = Api.vNone

            // pulling it all together
#if APP_SCHEME_DEV

            // https://localhost:3000
            // (1) https://api.dev.cemico.com
            static let currentHost              = Api.devHost
            static let currentBase1             = Api.currentScheme + Api.apiCName        + Api.currentHost
            static let currentBase              = Api.currentScheme                       + Api.currentHost
            static let currentRtcBase           = Api.currentBase

#elseif APP_SCHEME_INT

            // https://api.int.cemico.com
            static let currentHost              = Api.intHost
            static let currentBase              = Api.currentScheme + Api.apiCName        + Api.currentHost
            static let currentRtcBase           = Api.currentScheme + Api.currentRtc      + Api.currentHost + Api.currentVersion

#else // APP_SCHEME_PROD

            // https://api.cemico.com
            static let currentHost              = Api.prodHost
            static let currentBase              = Api.currentScheme + Api.currentApi      + Api.currentHost + Api.currentVersion
            static let currentRtcBase           = Api.currentScheme + Api.currentRtc      + Api.currentHost + Api.currentVersion
#endif
        }

        struct Endpoints {

            static let route1NoArgs             = "/route1"
            static let route2Args               = "/route2"
        }

        struct HeaderKeys {

            static let authorization            = "Authorization"
            static let appId                    = "App-ID"
        }

        struct HeaderValues {

            static let authorization            = ""
        }
    }

    enum ServerKeys: String {

        // keys both sent and received
        case token
        case error
        case message
    }

    enum DeviceKeys: String {

        case deviceName
        case platform
        case platformVersion
    }
}

extension Router {

    ///////////////////////////////////////////////////////////
    // computed properties
    ///////////////////////////////////////////////////////////

    static var baseURLString: String = {

        // all static parts of the url
        return Constants.Api.currentBase
    }()

    static var hostname: String = {

        return Constants.Api.apiCName + Constants.Api.currentHost
    }()

    static var baseRtcURLString: String = {

        // all static parts of the url
        return Constants.Api.currentRtcBase
    }()

    var method: Alamofire.HTTPMethod {

        switch self {

            // GETs
            case .route1NoArgs:
                return .get

            // POSTs
            case .route2Args:
                return .post
        }
    }

    var path: String {

        switch self {

            case .route1NoArgs:
                return Constants.Endpoints.route1NoArgs

            case .route2Args:
                return Constants.Endpoints.route2Args
        }
    }

    var addHeaders: Bool {

        // all secure except few
        switch self {

            case .route1NoArgs:
                return false

            // most add the header
            default:
                return true
        }
    }

    ///////////////////////////////////////////////////////////
    // header fields
    ///////////////////////////////////////////////////////////

    static var headers: [String: String] {

        // common headers
        get {

            var tmpHeaders: [String: String] = [:]
            var token = Settings.token

            // header - bearer
            if token.isEmpty {

                // use first accessor token if exists
                token = Constants.HeaderValues.authorization
            }

            if !token.isEmpty {

//                tmpHeaders[Constants.HeaderKeys.authorization] = "Bearer \(token)"
                tmpHeaders[Constants.HeaderKeys.authorization] = "\(token)"
            }

            // header - app id
            if let bundleId = Bundle.main.bundleIdentifier {

                // thought it would be nice to push this to server too, in case
                // another app comes out, can distinguish where the call is being made
                tmpHeaders[Constants.HeaderKeys.appId] = bundleId
            }

            return tmpHeaders
        }
    }
}

extension Router {

    ///////////////////////////////////////////////////////////
    // support enums
    ///////////////////////////////////////////////////////////

    enum RouterErrors: Error {

        case UnableToCreateURL
    }

    ///////////////////////////////////////////////////////////
    // internal request type enum
    ///////////////////////////////////////////////////////////

    fileprivate enum EncodeRequestType {

        case url, json, array, `default`
    }
}

extension Router: URLRequestConvertible {

    // helper function to wrap token setting before request generated
    func asURLRequest(with token: String) throws -> URLRequest {

        Settings.token = token
        return try asURLRequest()
    }

    //
    // returns a URL request or throws if an `Error` was encountered
    //
    // - throws: An `Error` if the underlying `URLRequest` is `nil`
    //
    // - returns: A URL request
    //

    public func asURLRequest() throws -> URLRequest {

        // setup URL
        guard let URL = Foundation.URL(string: Router.baseURLString) else {

            throw RouterErrors.UnableToCreateURL
        }

        // setup physical request
        var mutableURLRequest = URLRequest(url: URL.appendingPathComponent(path))
        mutableURLRequest.httpMethod = method.rawValue

        // add any headers if needed
        if addHeaders {

            for (key, value) in Router.headers {

                mutableURLRequest.setValue(value, forHTTPHeaderField: key)
            }
        }

        // provide any parameter encoding if needed
        switch self {

            // perhaps blocks for each type of EncodeRequestType

            // json encoding
            case .route2Args(let parameters):
                return encodeRequest(mutableURLRequest, requestType: .json, parameters: parameters)

//            // url example
//            case .updateABC(let parameters):
//                return encodeRequest(mutableURLRequest, requestType: .url, parameters: parameters)
//
//            // array example (body encoding of array values)
//            case .postABCResponses(let arrayItems):
//                return encodeRequest(mutableURLRequest, requestType: .array, arrayItems: arrayItems)

            // simple call, no parameters / no encoding
            case .route1NoArgs:       fallthrough
            default:
                return encodeRequest(mutableURLRequest, requestType: .default)
        }
    }

    private func encodeRequest(_ mutableURLRequest: URLRequest,
                               requestType: EncodeRequestType,
                               parameters: Attributes? = nil,
                               arrayItems: [Attributes]? = nil) -> URLRequest {

        var encodedMutableURLRequest = mutableURLRequest

        // sanity check that encoding parameters exist
//        guard let parameters = parameters, parameters.count > 0 else { return mutableURLRequest }
//        guard let urlOriginal = mutableURLRequest.url else { return mutableURLRequest }

        // encode requested data
        switch requestType {

            case .json:
                encodedMutableURLRequest = try! Alamofire.JSONEncoding.default.encode(mutableURLRequest, with: parameters)

            case .url:
                encodedMutableURLRequest = try! Alamofire.URLEncoding.default.encode(mutableURLRequest, with: parameters)

//                var urlComps = URLComponents(url: urlOriginal, resolvingAgainstBaseURL: false)
//                let queryItems = parameters.map({ return URLQueryItem(name: "\($0.key)", value: "\($0.value)") })
//                urlComps?.queryItems = queryItems
//                encodedMutableURLRequest.url = urlComps?.url

            case .array:

                if let arrayItems = arrayItems {

                    // encode array to body
                    do {

                        // pass data in body of request
                        let data = try JSONSerialization.data(withJSONObject: arrayItems, options: [])
                        encodedMutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        encodedMutableURLRequest.httpBody = data
                    }
                    catch let error as NSError {

                        printError("ERROR Array JSON serialization failed: \(error)")

                    }
                }

            default:
                // no encoding - use passed in mutableURLRequest
                break
        }

        if let url = encodedMutableURLRequest.url {

            printInfo("URL: \(url)")
        }
        return encodedMutableURLRequest
    }
}

extension Router: URLConvertible {

    func asURL() throws -> URL {

        do {

            // reuse existing framework to get fully composed url
            let urlRequest = try asURLRequest()
            if let url = urlRequest.url {

                return url
            }
        }
        catch let error as NSError {

            printError("ERROR \(#function): \(error)")
        }

        // error mapping
        throw RouterErrors.UnableToCreateURL
    }
}

