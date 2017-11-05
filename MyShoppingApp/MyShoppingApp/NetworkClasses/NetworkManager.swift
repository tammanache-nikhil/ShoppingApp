//
//  NetworkManager.swift
//  MyShoppingApp
//
//  Created by Nikhil Tammanache on 05/11/17.
//  Copyright © 2017 Nikhil. All rights reserved.
//

import Foundation
typealias SuccessBlock = (_ data: Any?, _ type: URLRequestManager) -> Void
typealias FailureBlock = (_ error: MyCustomError) -> Void

class NetworkManager: NSObject {
    static let defaultManager = NetworkManager()
    
    var taskQueue: OperationQueue = OperationQueue()
    private override init() {
        super.init()
        self.configureQueue()
    }
    
    /**
     Use below function to configure operation queue.
     */
    private func configureQueue() -> Void {
        self.taskQueue.maxConcurrentOperationCount = 3
    }
    
    /**
     Use below function to add request task and execute operation.
     */
    func addRequestTask(requestTask: URLRequestManager, success: @escaping(SuccessBlock), failure: @escaping(FailureBlock)) {
        //Create Network Operation
        let networkOperation = NetworkOperation(urlRequestManager: requestTask, success: success, failure: failure)
        self.addNetworkOperationToQueue(networkOperation: networkOperation)
    }
    
    /**
     Use below method to add the operation to queue
     */
    private func addNetworkOperationToQueue(networkOperation: NetworkOperation) {
        //Set operation Priority.
        addNetworkOperationPriority(networkOperation: networkOperation)
        //Add operation to Operation Queue
        taskQueue.addOperation(networkOperation)
    }
    
    /**
     Use below method to set operationPriority.
     */
    private func addNetworkOperationPriority(networkOperation: NetworkOperation) -> Void {
        if let urlRequestManager = networkOperation.urlRequestManager {
            switch urlRequestManager.operationPriority {
            case NetworkOperationPriority.kPriorityVeryHigh:
                networkOperation.queuePriority = .veryHigh
            case NetworkOperationPriority.kPriorityHigh:
                networkOperation.queuePriority = .high
            case NetworkOperationPriority.kPriorityNormal:
                networkOperation.queuePriority = .normal
            case NetworkOperationPriority.kPriorityLow:
                networkOperation.queuePriority = .low
            case NetworkOperationPriority.kPriorityVeryLow:
                networkOperation.queuePriority = .veryLow
            }
        }
    }
}
