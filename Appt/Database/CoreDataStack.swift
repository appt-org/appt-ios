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

    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving main ManagedObjectContext: \(error)")
            }
        }
    }

    lazy var model: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: moduleName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var directory: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }()

    lazy var coordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.model)

        let persistenStoreURL = self.directory.appendingPathComponent("\(moduleName).sqlite")

        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistenStoreURL, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption : true])
        } catch {
            fatalError("Persistent Store error: \(error)")
        }
        return coordinator
    }()

    lazy var context: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.coordinator
        return context
    }()
}

// MARK: - WebPage

extension CoreDataStack {
    
    func fetch<T: WebPage>(_ request: NSFetchRequest<T>, url: String) throws -> T? {
        request.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
        request.predicate = NSPredicate(format: "url LIKE %@", url)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    func fetch<T: WebPage>(_ request: NSFetchRequest<T>) throws -> [T] {
        request.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
        return try context.fetch(request)
    }
}
