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
  
  var sectionNameFromDate: String {
    get {
      return getFormattedDate()
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
  
}
