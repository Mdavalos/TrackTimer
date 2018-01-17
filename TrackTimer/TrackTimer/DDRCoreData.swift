//
//  DDRCoreData.swift
//  Contacts2
//
//  Created by Miguel Davalos on 3/8/17.
//  Copyright © 2017 Miguel Davalos. All rights reserved.
//

import Foundation
import CoreData

protocol DDRCoreData {
    associatedtype Entity: NSManagedObject
    
    static func items(for context: NSManagedObjectContext, matching predicate: NSPredicate?, sortedBy sorters: [NSSortDescriptor]?) -> [Entity]
}

extension DDRCoreData {
    static func items(for context: NSManagedObjectContext, matching predicate: NSPredicate? = nil, sortedBy sorters: [NSSortDescriptor]? = nil) -> [Entity]
    {
        var items: [Entity] = []
        context.performAndWait {
            let fetchRequest: NSFetchRequest<Entity> = Entity.fetchRequest() as! NSFetchRequest<Entity>
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = sorters
            do {
                items = try fetchRequest.execute()
            } catch {
                
            }
        }
        return items
    }
}
