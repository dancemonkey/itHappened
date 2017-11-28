//
//  Activity+CoreDataClass.swift
//  It Happened
//
//  Created by Drew Lanning on 8/31/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import Foundation
import CoreData

enum DateRange: Int {
  case week = 7
  case month = 30
  case quarter = 90
  case year = 365
}

@objc(Activity)
public class Activity: NSManagedObject {
  
  private var weekRange: [Date]?
  private var monthRange: [Date]?
  private var quarterRange: [Date]?
  private var yearRange: [Date]?
  
  let instanceFetchRange = -14

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
  
  func getAllDates() -> [Date]? {
    guard let instances = self.instance else {
      return nil
    }    
    var returnSet = Set<Date>()
    let cal = Calendar(identifier: .gregorian)
    for instance in instances {
      if let date = (instance as! Instance).date {
        returnSet.insert(cal.startOfDay(for: (date as Date)))
      }
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
  
  func getDateRange(for range: DateRange) -> [Date] {
    switch range {
    case .week:
      if weekRange != nil { return weekRange! }
    case .month:
      if monthRange != nil { return monthRange! }
    case .quarter:
      if quarterRange != nil { return quarterRange! }
    case .year:
      if yearRange != nil { return yearRange! }
    }
    
    let cal = Calendar(identifier: .gregorian)
    var dateRange: [Date] = [Date]()
    let startDate = Calendar.current.date(byAdding: .day, value: -(range.rawValue), to: Date())!
    for d in 1 ... range.rawValue {
      let newDate = Calendar.current.date(byAdding: .day, value: d, to: startDate)
      dateRange.append(cal.startOfDay(for: newDate!))
    }
    setDateRange(for: range, to: dateRange)
    return dateRange
  }
  
  private func setDateRange(for range: DateRange, to newRange: [Date]) {
    switch range {
    case .week:
      weekRange = newRange
    case .month:
      monthRange = newRange
    case .year:
      yearRange = newRange
    case .quarter:
      quarterRange = newRange
    }
  }
  
  func getInstanceRange() -> [Date] {
    let cal = Calendar(identifier: .gregorian)
    let fromDate = Calendar.current.date(byAdding: .day, value: instanceFetchRange, to: Date())
    let toDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
    return [cal.startOfDay(for: fromDate!), cal.startOfDay(for: toDate!)]
  }

}
