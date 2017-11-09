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
      let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
      let sortedInstances = instances.sortedArray(using: [sortDescriptor])
      return sortedInstances.first as? Instance
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
        formatter.dateFormat = "EEEE MMM d, yyyy"
        let dateToFind = formatter.string(from: date)
        return dateToFind == (inst as? Instance)?.getFormattedDate()
      }).count
      instanceCount = total
    }
    return instanceCount
  }
  
  func getAllDates() -> [String]? {
    guard let instances = self.instance else {
      return nil
    }
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE MMM d, yyyy"
    
    var returnSet = Set<String>()
    for instance in instances {
      returnSet.insert(formatter.string(from: (instance as! Instance).date! as Date))
    }
    
    return Array(returnSet)
  }
  
  func getAveragePerDay() -> Double {
    
    guard let inst = instance, inst.count > 0 else {
      return 0
    }
    
    let allInstances = instance?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)])
    let totalCount = Double(allInstances!.count)
    let earlierDate = (allInstances?.first as! Instance).date! as Date
    let diff = Double(Date().interval(ofComponent: .day, fromDate: earlierDate)) + 1
    
    return (totalCount / diff).roundTo(2)
  }

}
