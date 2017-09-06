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
  
  func addNewInstance() {
    let dm = DataManager()
    let instance = Instance(context: dm.context)
    instance.date = Date() as NSDate
    instance.activity = self
    self.addToInstance(instance)
    do {
      try dm.context.save()
    } catch {
      print("failed save in Activity addNewInstnace")
    }
  }
  
  func getTodaysTotal() -> Int {
    var todayCount = 0
    if let instances = self.instance {
      let total: Int = instances.filter({ (inst) -> Bool in
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        let today = formatter.string(from: Date())
        return today == (inst as? Instance)?.getFormattedDate()
      }).count
      todayCount = total
    }
    
    return todayCount
  }

}
