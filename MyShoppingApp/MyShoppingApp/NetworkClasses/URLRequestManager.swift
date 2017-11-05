//
//  URLRequestManager.swift
//  MyShoppingApp
//
//  Created by Nikhil Tammanache on 05/11/17.
//  Copyright © 2017 Nikhil. All rights reserved.
//

import UIKit

class URLRequestManager: NSObject, URLSessionDataDelegate {
    
    var requsetURLString: NSString = ""
    var requestHTTPMethodType: HTTPMethodType = HTTPMethodType.kHTTPUnknown
    var operationPriority: NetworkOperationPriority = NetworkOperationPriority.kPriorityVeryHigh
    var requestType: RequestType = RequestType.requestTypeUnkown
    var requestPayload: Any?
    var serverRequest: URLRequest? {
        return configureServerRequest()
    }
    
    init(requestType: RequestType, urlString: NSString, requestHTTPMethod: HTTPMethodType, operationPriority:NetworkOperationPriority, requestPayload: Any? = nil) {
        super.init()
        requestHTTPMethodType = requestHTTPMethod
        self.operationPriority = operationPriority
        self.requestPayload = requestPayload
        self.requsetURLString = urlString
        self.requestType = requestType
    }
    
    /**
     Use below method to get HTTP method type.
     */
    private func getHTTPMethodType(type: HTTPMethodType) -> String {
        switch type {
        case .kHTTPPost:
            return NetworkKeys.httpMethod_POST
        case .kHTTPPatch:
            return NetworkKeys.httpMethod_PATCH
        case .kHTTPPut:
            return NetworkKeys.httpMethod_PUT
        case .kHTTPGet:
            return NetworkKeys.httpMethod_GET
        case .kHTTPDelete:
            return NetworkKeys.httpMethod_DELETE
        default:
            return NetworkKeys.httpMethod_UNKNOWN
        }
    }
    
    /**
     Use below method to initialize URLRequest.
     */
    private func configureServerRequest() -> URLRequest? {
        var urlString = self.requsetURLString as String
        urlString = self.requsetURLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? urlString
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        var request = URLRequest(url: url)
        if requestHTTPMethodType != HTTPMethodType.kHTTPGet && requestHTTPMethodType != HTTPMethodType.kHTTPUnknown {
            if let jsonDict = requestPayload {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
                    request.setValue("\(jsonData.count)", forHTTPHeaderField: NetworkKeys.httpContentLengthKey)
                    request.httpBody = jsonData
                } catch _ {
                    
                }
            }
        }
        request.setValue(NetworkKeys.httpRequestHeaderValue_CONTENTTYPE, forHTTPHeaderField: NetworkKeys.httpRequestHeaderKey_CONTENTTYPE)
        request.addValue(NetworkKeys.httpRequestHeaderValue_CONTENTTYPE, forHTTPHeaderField: NetworkKeys.httpHeaderKeyAccept)
        request.httpMethod = getHTTPMethodType(type: requestHTTPMethodType)
        request.timeoutInterval = NetworkKeys.kRequestTimeOutInterval
        return request
    }
}
