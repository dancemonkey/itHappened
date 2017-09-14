//
//  Instance+CoreDataClass.swift
//  It Happened
//
//  Created by Drew Lanning on 8/31/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import Foundation
import CoreData

@objc(Instance)
public class Instance: NSManagedObject {

  func getFormattedDate() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE, MMM d, yyyy"
    return formatter.string(from: self.date! as Date)
  }
  
  @objc var sectionNameFromDate: String {
    get {
      return getColloquialDate()
    }
  }
  
  func getFormattedTime() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    return formatter.string(from: self.date! as Date)
  }
  
  func getDateAndTime() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d, h:mm a"
    return formatter.string(from: self.date! as Date)
  }
  
  func getColloquialDateAndTime() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE, MMM d, yyyy"
    if formatter.string(from: Date()) == formatter.string(from: self.date! as Date) {
      return "Today, \(getFormattedTime())"
    } else {
      return getDateAndTime()
    }
  }
  
  func getColloquialDate() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d, yyyy"
    if formatter.string(from: Date()) == formatter.string(from: self.date! as Date) {
      return "Today - \(formatter.string(from: self.date! as Date))"
    } else {
      return getFormattedDate()
    }
  }
  
}
