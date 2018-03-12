//
//  Runtime.swift
//  S4BA
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

///////////////////////////////////////////////////////////
// global scope helper methods to inject variables into extensions
///////////////////////////////////////////////////////////

//
// https://medium.com/@ttikitu/swift-extensions-can-add-stored-properties-92db66bce6cd#.r01lzgkqa
//

//
// getters (note: key type must match what you define as the key ... and doesn't have to be Sting)
//

func getExtensionVariable<ValueType: AnyObject> (

    _ base:         AnyObject,
    key:            UnsafePointer<String>,
    initializer:    () -> ValueType) -> ValueType {

    return getExtensionItem(base, key: key, type: .OBJC_ASSOCIATION_RETAIN, initializer: initializer)
}

func getExtensionDelegate<ValueType: AnyObject> (

    _ base:         AnyObject,
    key:            UnsafePointer<String>,
    initializer:    () -> ValueType) -> ValueType {

    return getExtensionItem(base, key: key, type: .OBJC_ASSOCIATION_ASSIGN, initializer: initializer)
}

func getExtensionItem<ValueType: AnyObject> (

    _ base:         AnyObject,
    key:            UnsafePointer<String>,
    type:           objc_AssociationPolicy,
    initializer:    () -> ValueType) -> ValueType  {

    // get requested object if exists
    if let associated = objc_getAssociatedObject(base, key) as? ValueType {

        return associated
    }

    // doesn't exist, init a new one, save, and return that
    let associated = initializer()
    setExtensionItem(base, key: key, value: associated, type: type)
    return associated
}

//
// setters
//

func setExtensionVariable<ValueType: AnyObject> (

    _ base:     AnyObject,
    key:        UnsafePointer<String>,
    value:      ValueType) {

    // set object
    setExtensionItem(base, key: key,  value: value, type: .OBJC_ASSOCIATION_RETAIN)
}

func setExtensionDelegate<ValueType: AnyObject> (

    _ base:     AnyObject,
    key:        UnsafePointer<String>,
    value:      ValueType) {

    // set delegate
    setExtensionItem(base, key: key,  value: value, type: .OBJC_ASSOCIATION_ASSIGN)
}

func setExtensionItem<ValueType: AnyObject> (

    _ base:     AnyObject,
    key:        UnsafePointer<String>,
    value:      ValueType,
    type:       objc_AssociationPolicy) {

    // set object
    objc_setAssociatedObject(base, key, value, type)
}

/*
    // example use
    public var pageIsInVisibleNodeProcess: Bool {

        get {

            return _pagesIsInVisibleNodesProcess.boolValue
        }

        set {

            _pagesIsInVisibleNodesProcess = NSNumber(value: newValue as Bool)
        }
    }

    fileprivate var _pagesIsInVisibleNodesProcess: NSNumber {

        get {

            return getExtensionVariable(self, key: &Constants.Keys.pageIsInVisibleNodes) {

                // init (using objc internal routines, needs to be reference type
                return NSNumber(value: Constants.Defaults.pageIsInVisibleNodeProcess as Bool)
            }
        }

        set {

            setExtensionVariable(self, key: &Constants.Keys.pageIsInVisibleNodes, value: newValue)
        }
    }
*/
