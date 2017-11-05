//
//  Constants.swift
//  MyShoppingApp
//
//  Created by Nikhil Tammanache on 05/11/17.
//  Copyright © 2017 Nikhil. All rights reserved.
//

import Foundation

enum HTTPMethodType: Int {
    case kHTTPGet = 0
    case kHTTPPut
    case kHTTPPost
    case kHTTPPatch
    case kHTTPDelete
    case kHTTPUnknown
}

enum NetworkOperationPriority: Int {
    case kPriorityVeryHigh
    case kPriorityHigh
    case kPriorityNormal
    case kPriorityLow
    case kPriorityVeryLow
}

// MARK: - URL Request Constants
enum RequestType: Int {
    case getAllProducts
    case requestTypeUnkown
}

struct NetworkKeys {
    static let httpMethod_POST = "POST"
    static let httpMethod_GET = "GET"
    static let httpMethod_PATCH = "PATCH"
    static let httpMethod_PUT = "PUT"
    static let httpMethod_DELETE = "DELETE"
    static let httpMethod_UNKNOWN = "UNKNOWN"
    static let httpHeaderKeyAccept = "Accept"
    static let httpContentLengthKey = "Content-Length"
    static let kRequestTimeOutInterval = 20.0
    static let httpRequestHeaderValue_CONTENTTYPE = "application/json"
    static let httpRequestHeaderKey_CONTENTTYPE = "Content-Type"
}

struct PayloadKeys {
    static let products = "products"
    static let productName = "productname"
    static let price = "price"
    static let vendorName = "vendorname"
    static let vendorAddress = "vendoraddress"
    static let productImg = "productImg"
    static let phoneNumber = "phoneNumber"
}
