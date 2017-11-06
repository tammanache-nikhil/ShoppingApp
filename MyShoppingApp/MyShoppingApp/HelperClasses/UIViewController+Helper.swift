//
//  UIViewController+Helper.swift
//  MyShoppingApp
//
//  Created by Nikhil Tammanache on 11/6/17.
//  Copyright © 2017 Nikhil. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    /// Show Alert controller with title and Message having OK as default button
    ///
    /// - Parameters:
    ///   - title: String?
    ///   - message: String?
    ///   - completion: Completion handlr called on ok action
    /// - Returns: UIAlertController
    @discardableResult
    func showAlert(buttonTitle: String = "OK", title: String?, message: String?,  completion: (() -> Void)?) -> UIAlertController {
        let action = UIAlertAction.init(title: buttonTitle, style: .default) { _ in }
        return showAlert(title: title, message: message, actions: [action])
    }
    
    /// Show Alert with title, message and action specified in parameter
    ///
    /// - Parameters:
    ///   - title: String
    ///   - message: String
    ///   - actions: Set of actions
    /// - Returns: UIAlertController
    @discardableResult
    func showAlert( title: String?, message: String?, actions: [UIAlertAction]) -> UIAlertController {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        DispatchQueue.main.async {
            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
            alertWindow.rootViewController = UIViewController()
            alertWindow.windowLevel = UIWindowLevelAlert + 1
            alertWindow.makeKeyAndVisible()
            alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
        }
        return alert
    }
}
