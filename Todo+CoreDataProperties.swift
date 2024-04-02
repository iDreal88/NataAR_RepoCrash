//
//  Todo+CoreDataProperties.swift
//  NataAR
//
//  Created by Denny Chandra Wijaya on 03/04/24.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var name: NSObject?

}

extension Todo : Identifiable {

}
