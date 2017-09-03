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
    do {
      try context.save()
    } catch {
      print("failed save in DataManager addNewActivity")
    }
  }
  
}
