//
//  CustomError.swift
//  MyShoppingApp
//
//  Created by Nikhil Tammanache on 05/11/17.
//  Copyright © 2017 Nikhil. All rights reserved.
//

import Foundation

enum MyCustomError: Error {
    case success
    case noConnection
    case recordNotFound
    case unauthorisedAccess
    case operationInQueue
    case requestTimeOut
    case unKnown
}

struct CustomError {
    
    // Use below function to get custom error code.
    static func myError(networkError: Error) -> MyCustomError {
        
        var myError = MyCustomError.unKnown
        
        let error = networkError as NSError
        switch error.code {
        case 401:
            myError = .unauthorisedAccess
        case 404:
            myError = .recordNotFound
        case 408:
            myError = .requestTimeOut
        case 900,-1009:
            myError = .noConnection
        default:
            myError = .unKnown
        }
        return myError
    }
}
