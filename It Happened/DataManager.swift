//
//  DataManager.swift
//  It Happened
//
//  Created by Drew Lanning on 8/31/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

class DataManager {
  
  var context: NSManagedObjectContext {
    get {
      return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
  }
  
  func save() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.saveContext()
  }
  
  func addNewActivity(called name: String) {
    let activity = Activity(context: context)
    activity.name = name
    activity.created = Date() as NSDate
    activity.sortOrder = Int32(try! self.context.count(for: Activity.fetchRequest()))
  }
  
  func setLastOpen() {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE, MMM d, yyyy"
    let today = formatter.string(from: Date())
    UserDefaults().setValue(today, forKey: "lastOpen")
  }
  
  func getLastOpen() -> String? {
    if let lastOpen = UserDefaults().object(forKey: "lastOpen") {
      return lastOpen as? String
    }
    return nil
  }
  
}
