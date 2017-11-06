//
//  DataBaseManager.swift
//  MyShoppingApp
//
//  Created by Nikhil Tammanache on 05/11/17.
//  Copyright © 2017 Nikhil. All rights reserved.
//

import Foundation
import CoreData

final class DatabaseManager {
    
    private init() {
    }
    
    // DataManager singleton.
    static let shared = DatabaseManager()
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MyShoppingApp")
        let description = NSPersistentStoreDescription()
        
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        description.setOption(FileProtectionType.complete as NSObject, forKey: NSPersistentStoreFileProtectionKey)
        container.persistentStoreDescriptions.append(description)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    /**
     This method save BackGround Context
     - Parameter context: The context to be saved.
     */
    private func saveBackgroundContext(_ context: NSManagedObjectContext) {
        if !context.hasChanges {
            return
        }
        context.performAndWait { [weak self] in
            do {
                try context.save()
                if let weakSelf = self, let parentContext = context.parent {
                    weakSelf.saveContext(context: parentContext)
                } else {
                    return
                }
            } catch {
                print("Error occured while saving background context")
            }
        }
    }
    
    /**
     Saves the context which is passed in calling method
     */
    func saveContext(context: NSManagedObjectContext) {
        if context == self.mainContext {
            self.saveContext()
        } else {
            self.saveBackgroundContext(context)
        }
    }
    /**
     This variable returns main context according to availability
     */
    public lazy var mainContext: NSManagedObjectContext = {
        let mainContext = self.persistentContainer.viewContext
        return mainContext
    }()
    
    /**
     This method return background context according to availability
     - Returns: The background context.
     */
    public func childContext() -> NSManagedObjectContext {
        let newThreadContext = self.persistentContainer.newBackgroundContext()
        newThreadContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return newThreadContext
    }
    
    /**
     This method create New Object With details provided.
     - Parameter name: The object name.
     - Parameter context: The context in which object is created.
     - Returns: The created object.
     */
    func createNewObjectWith(name: String, context: NSManagedObjectContext) -> NSManagedObject {
        let desc: NSEntityDescription = NSEntityDescription.entity(forEntityName: name, in:context)!
        let object: NSManagedObject = NSManagedObject(entity: desc, insertInto: context)
        return object
    }
    
    /**
     This method fetch Object for details provided.
     - Parameter type: The object type.
     - Parameter predicate: The predicate condition if any.
     - Parameter sortDescriptor: The sortDescriptor if any.
     - Parameter context: Context to use.
     - Returns: The fetched object.
     */
    func fetchObject(ofType type: String, inContext context: NSManagedObjectContext, withPredicate predicate: NSPredicate? = nil, andSortDescriptor sortDescriptor: [NSSortDescriptor]? = nil) -> NSManagedObject? {
        if let results = fetchObjects(ofType: type, inContext: context, withPredicate: predicate, andSortDescriptor: sortDescriptor), results.count > 0 {
            return results.first
        }
        return nil
    }
    
    /**
     This method fetch Objects for details provided.
     - Parameter type: The object type.
     - Parameter predicate: The predicate condition if any.
     - Parameter sortDescriptor: The sortDescriptor if any.
     - Parameter context: Context to use.
     - Returns: The fetched objects.
     */
    func fetchObjects(ofType type: String, inContext context: NSManagedObjectContext, withPredicate predicate: NSPredicate? = nil, andSortDescriptor sortDescriptor: [NSSortDescriptor]? = nil) -> [NSManagedObject]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:type)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptor
        do {
            let results = try context.fetch(request)
            return results as? [NSManagedObject]
        } catch _ {
            return nil
        }
    }
}
