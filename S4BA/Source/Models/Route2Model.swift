//
//  Route2Model.swift
//  S4BA
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

// NSCoding for archiving and Codable for json
class Route2Model: NSCoding, Codable, CustomStringConvertible, Equatable {

    ///////////////////////////////////////////////////////////
    // enums
    ///////////////////////////////////////////////////////////

    // json auto-serialization into object creation
    private enum CodingKeys: String, CodingKey {

        // keys converted from server key to new local key

        // converted for readability
        case maxWidgets     = "widget-count"

        // converted to wrap optionals
        case _error         = "error"
        case _version       = "version"

        // keys unchanged
        case isWidget
        case widgetRatio
        case widgets
    }

    // archiving
    enum ArchiveKeys: String {

        // swift 4/3.2 nice, will auto-rawValue a String to match enum case
        // note: enums do not allow you to assign value from struct, only literals
        case isWidget
        case maxWidgets
        case widgetRatio
        case widgets
        case error

        // synthesized
        case version

        static var all: [ArchiveKeys] = [ isWidget, .maxWidgets, .widgetRatio, .widgets, .error, .version ]

        func value(for model: Route2Model) -> Any {

            // getter
            switch self {

                case .isWidget:         return model.isWidget
                case .maxWidgets:       return model.maxWidgets
                case .widgetRatio:      return model.widgetRatio
                case .widgets:          return model.widgets
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
    var isWidget: Bool
    var maxWidgets: Int
    var widgetRatio: Float
    var widgets: [String]

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

        // bools
        isWidget    = aDecoder.decodeBool(forKey: ArchiveKeys.isWidget.rawValue)

        // ints
        maxWidgets  = aDecoder.decodeInteger(forKey: ArchiveKeys.maxWidgets.rawValue)

        // floats
        widgetRatio = aDecoder.decodeFloat(forKey: ArchiveKeys.widgetRatio.rawValue)

        // strings
        _error      = aDecoder.decodeObject(forKey: ArchiveKeys.error.rawValue) as? String ?? ""
        _version    = aDecoder.decodeObject(forKey: ArchiveKeys.version.rawValue) as? String ?? ""

        // arrays
        widgets     = aDecoder.decodeObject(forKey: ArchiveKeys.widgetRatio.rawValue)  as? [String] ?? []

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

                // bool types
                case .isWidget:
                    let value = Bool.from(any: key.value(for: self))
                    aCoder.encode(value, forKey: key.rawValue)

                // int types
                case .maxWidgets:
                    let value = Int.from(any: key.value(for: self))
                    aCoder.encode(value, forKey: key.rawValue)

                // float types
                case .widgetRatio:
                    let value = Int.from(any: key.value(for: self))
                    aCoder.encode(value, forKey: key.rawValue)

                // string types
                case .error, .version:
                    let value = String.from(any: key.value(for: self))
                    aCoder.encode(value, forKey: key.rawValue)

                // array types
                case .widgets:
                    let value = Array<String>.from(any: key.value(for: self))
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

    func equalTo(_ selfTest: Route2Model) -> Bool {

        // object check, i.e. same physical object
        guard self !== selfTest else { return true }

        // property level equality check
        return  self.isWidget       == selfTest.isWidget        &&
                self.maxWidgets     == selfTest.maxWidgets      &&
                self.widgetRatio    == selfTest.widgetRatio     &&
                self.widgets        == selfTest.widgets
    }
}

///////////////////////////////////////////////////////////
// global level protocol conformance
///////////////////////////////////////////////////////////

func ==(lhs: Route2Model, rhs: Route2Model) -> Bool {

    // call into class so class so any potential heirarchy is maintained
    return lhs.equalTo(rhs)
}


