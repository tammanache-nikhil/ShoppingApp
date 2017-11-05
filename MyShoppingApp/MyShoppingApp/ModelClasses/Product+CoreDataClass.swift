//
//  Product+CoreDataClass.swift
//  MyShoppingApp
//
//  Created by Nikhil Tammanache on 05/11/17.
//  Copyright © 2017 Nikhil. All rights reserved.
//

import Foundation
import CoreData

@objc(Product)
public class Product: NSManagedObject {
    
    
    /// Use below method to create or update new Product.
    ///
    /// - Parameters:
    ///   - context: ManagedObjectContext in which Product should be created or updated
    ///   - payload: payload received from server.
    /// - Returns: newly created Product.
    @discardableResult
    class func createOrUpdate(inContext context: NSManagedObjectContext, withPayload payload: [String : Any]) -> Product? {
        let databaseManager = DatabaseManager.shared
        guard let productName = payload[PayloadKeys.productName] as? String else {
            // Considering product name as must value for a Product.
           return nil
        }
        var productObj = databaseManager.fetchObject(ofType: Product.stringName, inContext: context, withPredicate: NSPredicate(format: "productName = %@", productName), andSortDescriptor: nil) as? Product
        if productObj == nil {
           productObj = databaseManager.createNewObjectWith(name: Product.stringName, context: context) as? Product
        }
        productObj?.updateProperties(withPayload: payload)
        return productObj
    }
    
    
    /// Use below function to update properties of Product.
    ///
    /// - Parameter payload: payload received from server.
    func updateProperties(withPayload payload: [String : Any]) {
        productName = payload[PayloadKeys.productName] as? String
        if let price = payload[PayloadKeys.price] as? String {
           productPrice = Int64(price) ?? 0
        }
        vendorName = payload[PayloadKeys.vendorName] as? String
        vendorAddress = payload[PayloadKeys.vendorAddress] as? String
        imageURL = payload[PayloadKeys.productImg] as? String
        phoneNumber = payload[PayloadKeys.phoneNumber] as? String
    }

}
