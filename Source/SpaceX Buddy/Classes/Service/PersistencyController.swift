//
//  PersistencyController.swift
//  SpaceX Buddy
//
//  Created by Jenei Viktor on 2020. 10. 15..
//

import Foundation
import CoreData

extension SpaceXBuddy {
    class PersistencyController {
        enum SetupResult {
            case success
            case error(error: Error)
        }
        
        static let shared = PersistencyController()
        private var persistentContainer: NSPersistentContainer!
        
        var viewContext : NSManagedObjectContext {
            return persistentContainer.viewContext
        }
        
        var backgroundContext : NSManagedObjectContext {
            return persistentContainer.newBackgroundContext()
        }
        
        private init() {}

        func setup(completion: ((SetupResult) -> Swift.Void)?) {
            guard persistentContainer == nil else {
                return
            }
            
            persistentContainer = NSPersistentContainer(name: "SpaceXBuddy")
            persistentContainer.loadPersistentStores { (storeDescription : NSPersistentStoreDescription, error : Error?) in
                if let error = error {
                    completion?(.error(error: error))
                }
                else {
                    completion?(.success)
                }
            }
        }
    }
}
