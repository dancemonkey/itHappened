//
//  Activity+CoreDataClass.swift
//  It Happened
//
//  Created by Drew Lanning on 8/31/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import Foundation
import CoreData

@objc(Activity)
public class Activity: NSManagedObject {
  
  var lastInstance: Instance? {
    get {
      return self.instance?.lastObject as? Instance
    }
  }
  
  func setSortOrder(to index: Int) {
    self.sortOrder = Int32(index)
  }

}
