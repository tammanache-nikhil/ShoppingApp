//
//  NetworkOperation.swift
//  MyShoppingApp
//
//  Created by Nikhil Tammanache on 05/11/17.
//  Copyright © 2017 Nikhil. All rights reserved.
//

import UIKit

class NetworkOperation: Operation, URLSessionDataDelegate {
    var defaultSession: URLSession {
        let sessionConfiguration = URLSessionConfiguration.default
        return URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
    }
    var dataTask: URLSessionDataTask?
    var requestPayload = [String : Any]()
    var urlRequestManager: URLRequestManager?
    var requestType: RequestType = RequestType.requestTypeUnkown
    var successBlock: ((_ data: Any?, _ type: URLRequestManager) -> Void)?
    var failureBlock: ((_ error: MyCustomError) -> Void)?

    init(urlRequestManager: URLRequestManager, success: ((Any?, URLRequestManager) -> Void)?, failure: ((MyCustomError) -> Void)?) {
        super.init()
        self.urlRequestManager = urlRequestManager
        successBlock = success
        failureBlock = failure
    }

    override func main() {
        self.makeAPICallForRequestType(urlRequestManager: self.urlRequestManager, completion: {(payload, responseHeaders, error ) in
            if error != nil {
                self.failureBlock?(CustomError.myError(networkError: error!))
            } else {
                do {
                    let response = responseHeaders as? HTTPURLResponse
                    
                    let parsedJson = try JSONSerialization.jsonObject(with: payload!, options: JSONSerialization.ReadingOptions.allowFragments)
                    if response?.statusCode == 200 || response?.statusCode == 201 {
                        self.successBlock?(parsedJson, self.urlRequestManager!)
                    } else {
                        let responseMsg = parsedJson as? [AnyHashable : Any]
                        let err = NSError(domain: "HttpResponseErrorDomain", code: (response?.statusCode)!, userInfo: responseMsg as? [String : Any])
                        self.failureBlock?(CustomError.myError(networkError: err))
                    }
                } catch let exception {
                    self.failureBlock?(CustomError.myError(networkError: exception))
                }
            }
        })
    }

    /*
     * Use this method to Make API Call via URLSession
     */
    func makeAPICallForRequestType(urlRequestManager: URLRequestManager?, completion: @escaping(Data?, URLResponse?, Error?) -> Swift.Void) {

        if let requestManager = self.urlRequestManager, let request = requestManager.serverRequest {
            self.dataTask = self.defaultSession.dataTask(with: request, completionHandler:completion)
            self.dataTask?.resume()
        } else {
            let err = NSError(domain: "HttpResponseErrorDomain", code: 903, userInfo: ["message" : "Invalid Request"])
            completion(nil,nil, err)
        }
    }
}
