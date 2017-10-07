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
      guard let instances = self.instance else {
        return nil
      }
      var interval: Double? = nil
      var mostRecentInstance: Instance? = nil
      for inst in instances {
        if interval == nil {
          interval = (inst as! Instance).date?.timeIntervalSinceReferenceDate
          mostRecentInstance = inst as? Instance
        } else {
          if ((inst as! Instance).date?.timeIntervalSinceReferenceDate)! > interval! {
            interval = (inst as! Instance).date?.timeIntervalSinceReferenceDate
            mostRecentInstance = inst as? Instance
          }
        }
      }
      return mostRecentInstance //self.instance?.lastObject as? Instance // fix to return most recent object by date
    }
  }
  
  func setSortOrder(to index: Int) {
    self.sortOrder = Int32(index)
  }
  
  func deleteAllInstances() {
    for inst in self.instance! {
      self.managedObjectContext?.delete(inst as! NSManagedObject)
    }
  }
  
  func addNewInstance(withContext context: NSManagedObjectContext) {
    let instance = Instance(context: context)
    instance.date = Date() as NSDate
    instance.activity = self
    self.addToInstance(instance)
  }
  
  func getInstanceCount(forDate date: Date) -> Int {
    var instanceCount = 0
    if let instances = self.instance {
      let total: Int = instances.filter({ (inst) -> Bool in
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        let dateToFind = formatter.string(from: date)
        return dateToFind == (inst as? Instance)?.getFormattedDate()
      }).count
      instanceCount = total
    }
    return instanceCount
  }

}
