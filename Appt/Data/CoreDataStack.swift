//
//  CoreDataStack.swift
//  ApptApp
//
//  Created by Jan Jaap de Groot on 02/09/2022.
//  Copyright © 2022 Stichting Appt. All rights reserved.
//

import CoreData

class CoreDataStack: NSObject {
    
    let moduleName = "Database"

    func saveToMainContext() { // Just a helper method for removing boilerplate code when you want to save. Remember this will be done on the main thread if called.
        if objectContext.hasChanges {
            do {
                try objectContext.save()
            } catch {
                print("Error saving main ManagedObjectContext: \(error)")
            }
        }
    }

    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: moduleName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var applicationDocumentsDirectory: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

        let persistenStoreURL = self.applicationDocumentsDirectory.appendingPathComponent("\(moduleName).sqlite")

        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistenStoreURL, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption : true])
        } catch {
            fatalError("Persistent Store error: \(error)")
        }
        return coordinator
    }()

    lazy var objectContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType) // As stated in the documentation change this depending on your need, but i recommend sticking to main thread if possible.

        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        return context
    }()
}
