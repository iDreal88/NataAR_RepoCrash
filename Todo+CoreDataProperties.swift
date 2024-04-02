//
//  Todo+CoreDataProperties.swift
//  NataAR
//
//  Created by Oey Darryl Valencio Wijaya on 29/03/24.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var name: String?

}

extension Todo : Identifiable {

}
