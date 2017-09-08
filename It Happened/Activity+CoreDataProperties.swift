//
//  Activity+CoreDataProperties.swift
//  It Happened
//
//  Created by Drew Lanning on 9/8/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import Foundation
import CoreData


extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var color: String?
    @NSManaged public var icon: String?
    @NSManaged public var name: String?
    @NSManaged public var sortOrder: Int32
    @NSManaged public var created: NSDate?
    @NSManaged public var instance: NSOrderedSet?

}

// MARK: Generated accessors for instance
extension Activity {

    @objc(insertObject:inInstanceAtIndex:)
    @NSManaged public func insertIntoInstance(_ value: Instance, at idx: Int)

    @objc(removeObjectFromInstanceAtIndex:)
    @NSManaged public func removeFromInstance(at idx: Int)

    @objc(insertInstance:atIndexes:)
    @NSManaged public func insertIntoInstance(_ values: [Instance], at indexes: NSIndexSet)

    @objc(removeInstanceAtIndexes:)
    @NSManaged public func removeFromInstance(at indexes: NSIndexSet)

    @objc(replaceObjectInInstanceAtIndex:withObject:)
    @NSManaged public func replaceInstance(at idx: Int, with value: Instance)

    @objc(replaceInstanceAtIndexes:withInstance:)
    @NSManaged public func replaceInstance(at indexes: NSIndexSet, with values: [Instance])

    @objc(addInstanceObject:)
    @NSManaged public func addToInstance(_ value: Instance)

    @objc(removeInstanceObject:)
    @NSManaged public func removeFromInstance(_ value: Instance)

    @objc(addInstance:)
    @NSManaged public func addToInstance(_ values: NSOrderedSet)

    @objc(removeInstance:)
    @NSManaged public func removeFromInstance(_ values: NSOrderedSet)

}
