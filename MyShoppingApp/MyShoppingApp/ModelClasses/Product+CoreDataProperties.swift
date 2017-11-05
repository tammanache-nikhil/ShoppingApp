//
//  Product+CoreDataProperties.swift
//  MyShoppingApp
//
//  Created by Nikhil Tammanache on 05/11/17.
//  Copyright © 2017 Nikhil. All rights reserved.
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var productName: String?
    @NSManaged public var productPrice: Int64
    @NSManaged public var vendorName: String?
    @NSManaged public var vendorAddress: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var phoneNumber: String?

}
