//
//  Instance+CoreDataProperties.swift
//  It Happened
//
//  Created by Drew Lanning on 8/31/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import Foundation
import CoreData


extension Instance {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Instance> {
        return NSFetchRequest<Instance>(entityName: "Instance")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var note: String?
    @NSManaged public var activity: Activity?

}
