//
//  QueueMgr.swift
//  S4BA
//
//  Created by Dave Rogers on 3/11/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import Foundation

class QueueMgr {

    ///////////////////////////////////////////////////////////
    // data members
    ///////////////////////////////////////////////////////////

    // swift - thread safe and lazy init
    static let shared = QueueMgr()

    ///////////////////////////////////////////////////////////
    // lifecycle
    ///////////////////////////////////////////////////////////

    // private ensures only one instance, defined above
    private init() {

        // mirror the default concurrent queues of DispatchQueue, except provide our own name - much easier when debugging
        // https://developer.apple.com/library/ios/documentation/Performance/Conceptual/EnergyGuide-iOS/PrioritizeWorkWithQoS.html

        //
        // create our custom queues
        //

        struct Constants {

            enum Concurrent: String {

                case utility        = "concurrent-utility"
                case `default`      = "concurrent-default"
                case userInitiated  = "concurrent-userinitiated"
            }

            enum Serial: String {

                case utility        = "serial-utility"
                case `default`      = "serial-default"
            }
        }

        // utility
        let concurrentUtilityName       = companyReverseDomain + Constants.Concurrent.utility.rawValue
        let serialUtilityName           = companyReverseDomain + Constants.Serial.utility.rawValue

        // default
        let concurrentDefaultName       = companyReverseDomain + Constants.Concurrent.default.rawValue
        let serialDefaultName           = companyReverseDomain + Constants.Serial.default.rawValue

        // user initiated
        let concurrentUserInitiatedName = companyReverseDomain + Constants.Concurrent.userInitiated.rawValue

        // lo level, 2 of 5, good non-urgent queue
        _concurrentDispatchQueueUtility = DispatchQueue(label: concurrentUtilityName,
                                                        qos: DispatchQoS(qosClass: .utility, relativePriority: 0),
                                                        attributes: .concurrent)
        _serialDispatchQueueUtility = DispatchQueue(label: serialUtilityName,
                                                    qos: DispatchQoS(qosClass: .utility, relativePriority: 0))

        // mid level, 3 of 5, good general queue
        _concurrentDispatchQueueDefault = DispatchQueue(label: concurrentDefaultName,
                                                        qos: DispatchQoS(qosClass: .default, relativePriority: 0),
                                                        attributes: .concurrent)

        _serialDispatchQueueDefault = DispatchQueue(label: serialDefaultName,
                                                    qos: DispatchQoS(qosClass: .default, relativePriority: 0))

        // midHi level, 4 of 5, just below main UI thread, use sparingly when user waiting on something
        _concurrentDispatchQueueUserInitiated = DispatchQueue(label: concurrentUserInitiatedName,
                                                              qos: DispatchQoS(qosClass: .userInitiated, relativePriority: 0),
                                                              attributes: .concurrent)

        // note: the one and only main queue is the Hi, 5 of 5
        printInfo("\(String.className(ofSelf: self)).\(#function)")
    }

    ///////////////////////////////////////////////////////////
    // enums
    ///////////////////////////////////////////////////////////

    enum PriorityQueue {

        // global system queues
        case sysHi, sysMidHi, sysMidLo, sysLo

        // local non-shared queues
        case localHi, localMid, localMidSerial, localLo, localLoSerial
    }

    ///////////////////////////////////////////////////////////
    // ivars
    ///////////////////////////////////////////////////////////

    fileprivate var _concurrentDispatchQueueUtility : DispatchQueue
    fileprivate var _serialDispatchQueueUtility : DispatchQueue
    fileprivate var _concurrentDispatchQueueDefault : DispatchQueue
    fileprivate var _serialDispatchQueueDefault : DispatchQueue
    fileprivate var _concurrentDispatchQueueUserInitiated : DispatchQueue

    ///////////////////////////////////////////////////////////
    // properties
    ///////////////////////////////////////////////////////////

    var isMainThread: Bool {

        return Thread.isMainThread
    }

    var currentThreadName: String {

        get {

            if let name = Thread.current.name {

                return name
            }

            return "unnamed"
        }
    }

    var currentQueueName: String {

        // http://stackoverflow.com/questions/39553171/how-to-get-the-current-queue-name-in-swift-3
        let label = __dispatch_queue_get_label(nil)
        if let name = String(cString: label, encoding: .utf8) {

            return name
        }

        return ""
    }

    var currentQueuePriorityName: String {

        let threadQoS = Thread.current.qualityOfService

        return threadQoS.description
    }

    var currentQueuePriorityValue: Int {

        let threadQoS = Thread.current.qualityOfService
        return threadQoS.rawValue
    }

    //
    // more info: https://developer.apple.com/library/mac/documentation/Performance/Reference/GCD_libdispatch_Ref/index.html
    //            https://developer.apple.com/library/ios/documentation/Performance/Conceptual/EnergyGuide-iOS/PrioritizeWorkWithQoS.html
    //
    // for ref on timers: https://developer.apple.com/library/ios/documentation/Performance/Conceptual/EnergyGuide-iOS/MinimizeTimerUse.html#//apple_ref/doc/uid/TP40015243-CH41-SW1
    //

    var GlobalMainQueue: DispatchQueue {

        // system main UI thread - only one
        return DispatchQueue.main
    }

    var GlobalUserInteractiveQueue: DispatchQueue {

        // system main UI thread, same as GlobalMainQueue, priority (0x21)
        return DispatchQueue.global(qos:.userInteractive)
    }

    var GlobalUserInitiatedQueue: DispatchQueue {

        // system concurrent background thread queue, differing from other concurrent queues only by priority (0x19)
        // DISPATCH_QUEUE_PRIORITY_HIGH
        return DispatchQueue.global(qos: .userInitiated)
    }

    var GlobalDefaultQueue: DispatchQueue {

        // system concurrent background thread queue, differing from other concurrent queues only by priority (0x15)
        // DISPATCH_QUEUE_PRIORITY_DEFAULT
        return DispatchQueue.global(qos:.default)
    }

    var GlobalUtilityQueue: DispatchQueue {

        // system concurrent background thread queue, differing from other concurrent queues only by priority (0x11)
        // DISPATCH_QUEUE_PRIORITY_LOW
        return DispatchQueue.global(qos:.utility)
    }

    var GlobalBackgroundQueue: DispatchQueue {

        // system concurrent background thread queue, differing from other concurrent queues only by priority (0x09)
        // DISPATCH_QUEUE_PRIORITY_BACKGROUND
        return DispatchQueue.global(qos:.background)
    }

    var LocalLoQueue: DispatchQueue {

        // level 2 qos fifo execution of just our added items running concurrently, i.e. no preservation of finish order
        return _concurrentDispatchQueueUtility
    }

    var LocalLoQueueSerial: DispatchQueue {

        // level 2 qos fifo execution of just our added items running serially, i.e. YES preservation of finish order
        return _serialDispatchQueueUtility
    }

    var LocalDefaultQueue: DispatchQueue {

        // level 3 qos fifo execution of just our added items running concurrently, i.e. no preservation of finish order
        return _concurrentDispatchQueueDefault
    }

    var LocalDefaultQueueSerial: DispatchQueue {

        return _serialDispatchQueueUtility
    }

    var LocalHiQueue: DispatchQueue {

        // level 4 qos fifo execution of just our added items running concurrently, i.e. no preservation of finish order
        return _concurrentDispatchQueueUserInitiated
    }

    ///////////////////////////////////////////////////////////
    // api
    ///////////////////////////////////////////////////////////

    func backgroundAfter(_ delayInMS: Int = 0, priorityQueue: PriorityQueue = .localMid, task: @escaping () -> Void) {

        // sanity
        let delay = max(delayInMS, 0)

        // background queue with delay
        let queue = getDispatchQueue(priorityQueue)
        threadAfter(queue, delayInMS: delay, task: task)
    }

    func mainAfter(_ delayInMS: Int = 0, task: @escaping () -> Void) {

        // sanity
        let delay = max(delayInMS, 0)

        threadAfter(GlobalMainQueue, delayInMS: delay, task: task)
    }

    fileprivate func threadAfter(_ queue: DispatchQueue, delayInMS: Int = 0, task: @escaping () -> Void) {

        // sanity
        let delay = max(delayInMS, 0)

        // delay value is in milliseconds
        let popTime = DispatchTime.now() + .milliseconds(delay)
        queue.asyncAfter(deadline: popTime) {

            task()
        }
    }

    func mainSync(_ task: @escaping () -> Void) {

        GlobalMainQueue.sync {

            task()
        }
    }

    func mainAsync(_ task: @escaping () -> Void) {

        GlobalMainQueue.async {

            task()
        }
    }

    func backgroundSync(_ task: @escaping () -> Void) {

        LocalLoQueueSerial.sync {

            task()
        }
    }

    func backgroundAsync(_ priorityQueue: PriorityQueue = .localMid, task: @escaping () -> Void) {

        let queue = getDispatchQueue(priorityQueue)
        queue.async {

            task()
        }
    }

    // simulate barrier with sync execution
    func backgroundBarrierSync(priorityQueue: PriorityQueue = .localMid, task: @escaping () -> Void) {

        // note: using sync for inline immediate execution, for instance when results need to be returned
        let queue = getDispatchQueue(priorityQueue)
        queue.sync() {

            task()
        }
    }

    // barrier allows concurrent queues to act like serial for an execution
    func backgroundBarrierAsync(priorityQueue: PriorityQueue = .localMid, task: @escaping () -> Void) {

        // note: queue should be concurrent, doesn't make sense to a serialbarrier queue
        let queue = getDispatchQueue(priorityQueue)
        queue.async(flags: .barrier) {

            task()
        }
    }

    ///////////////////////////////////////////////////////////
    // helpers
    ///////////////////////////////////////////////////////////

    fileprivate func getDispatchQueue(_ priorityQueue: PriorityQueue) -> DispatchQueue {

        switch priorityQueue {

            case .sysHi:
                return GlobalUserInitiatedQueue

            case .sysMidHi:
                return GlobalDefaultQueue

            case .sysMidLo:
                return GlobalUtilityQueue

            case .sysLo:
                return GlobalBackgroundQueue

            case .localHi:
                return LocalHiQueue

            case .localMid:
                return LocalDefaultQueue

            case .localMidSerial:
                return LocalDefaultQueueSerial

            case .localLo:
                return LocalLoQueue

            case .localLoSerial:
                return LocalLoQueueSerial
            }
    }
}
