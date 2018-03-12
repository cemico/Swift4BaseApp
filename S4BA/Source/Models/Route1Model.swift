//
//  Route1Model.swift
//  S4BA
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

// NSCoding for archiving and Codable for json
class Route1Model: NSCoding, Codable, CustomStringConvertible, Equatable {

    ///////////////////////////////////////////////////////////
    // enums
    ///////////////////////////////////////////////////////////

    // json auto-serialization into object creation
    private enum CodingKeys: String, CodingKey {

        // keys converted from server key to new local key

        // converted for readability

        // converted to wrap optionals
        case _error         = "error"
        case _version       = "version"

        // keys unchanged
    }

    // archiving
    enum ArchiveKeys: String {

        // swift 4/3.2 nice, will auto-rawValue a String to match enum case
        // note: enums do not allow you to assign value from struct, only literals
        case error

        // synthesized
        case version

        static var all: [ArchiveKeys] = [ .error, .version ]

        func value(for model: Route1Model) -> Any {

            // getter
            switch self {

                case .error:            return model.error
                case .version:          return model.version
            }
        }
    }

    private enum Versions: String {

        struct Constants {

            // number of fractional digits supported
            static let versionPrecision = modelObjectVersionPrecision
        }

        // version the model to allow upgrade path if model changes in future
        case v1_00 = "1.00"

        // latest version
        static var currentVersion = Versions.v1_00
    }

    ///////////////////////////////////////////////////////////
    // data members
    ///////////////////////////////////////////////////////////

    // see custom coding keys for matching variables / keys

    // optionals (note: private scope works with Codable protocol)
    private var _error: String?

    // synthesized / optional (note: private scope works with Codable protocol)
    private var _version: String?

    ///////////////////////////////////////////////////////////
    // computed properties to wrap optionals
    ///////////////////////////////////////////////////////////

    var error: String {

        return _error ?? ""
    }

    var version: String {

        return _version ?? Versions.currentVersion.rawValue
    }

    //
    // NSCoding protocol
    //

    required init?(coder aDecoder: NSCoder) {

        //
        // used to restore / unarchive a previous value which was archived / encoded
        //

        // strings
        _error      = aDecoder.decodeObject(forKey: ArchiveKeys.error.rawValue) as? String ?? ""
        _version    = aDecoder.decodeObject(forKey: ArchiveKeys.version.rawValue) as? String ?? ""

        // if NSObject is super, need init: after variables initialized
        //        super.init()

        // check for upgrade
        updateToCurrent()
    }

    func encode(with aCoder: NSCoder) {

        //
        // used to encode / archive this object
        //

        // save
        for key in ArchiveKeys.all {

            // coerce from Any into native types
            switch key {

                // string types
                case .error, .version:
                    let value = String.from(any: key.value(for: self))
                    aCoder.encode(value, forKey: key.rawValue)
            }
        }
    }

    ///////////////////////////////////////////////////////////
    // helpers
    ///////////////////////////////////////////////////////////

    private func updateToCurrent() {

        // check for no prior version
        guard !version.isEmpty else {

            _version = Versions.currentVersion.rawValue
            return
        }

        // example versioning logic
        guard version != Versions.currentVersion.rawValue else {

            // same version - no upgrade
            return
        }

        // upgrade older version to current, could be actions at each version change
        if version == Versions.v1_00.rawValue {

            // upgrade from 1.00 to current

            // udpate version
            _version = Versions.v1_00.rawValue
        }
    }

    ///////////////////////////////////////////////////////////
    // equality helper
    ///////////////////////////////////////////////////////////

    func equalTo(_ selfTest: Route1Model) -> Bool {

        // object check, i.e. same physical object
        guard self !== selfTest else { return true }

        // property level equality check
        return true
    }
}

///////////////////////////////////////////////////////////
// global level protocol conformance
///////////////////////////////////////////////////////////

func ==(lhs: Route1Model, rhs: Route1Model) -> Bool {

    // call into class so class so any potential heirarchy is maintained
    return lhs.equalTo(rhs)
}

