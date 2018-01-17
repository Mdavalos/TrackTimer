//
//  CoreDataStack.swift
//  Contacts2
//
//  Created by Miguel Davalos on 3/8/17.
//  Copyright © 2017 Miguel Davalos. All rights reserved.
//

import Foundation
import CoreData

//use name of .xcdatamodeld file
let MODEL_NAME = "TrackTimer"

class CoreDataStack {
    
    // singleton pattern
    // make init private so must use shared property
    private init() {}
    
    static let shared = CoreDataStack()
    
    var errorHandler: (Error) -> Void = {_ in }
    
    //#1
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: MODEL_NAME)
        container.loadPersistentStores(completionHandler: { [weak self](storeDescription, error) in
            if let error = error {
                NSLog("CoreData error \(error), \(String(describing: error._userInfo))")
                self?.errorHandler(error)
            }
        })
        return container
    }()
    
    //#2
    lazy var viewContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    //#3
    // Optional
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    //#4
    func performForegroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.viewContext.perform {
            block(self.viewContext)
        }
    }
    
    //#5
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.persistentContainer.performBackgroundTask(block)
    }
    
    func save() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
