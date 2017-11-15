//
//  AppDelegate.swift
//  It Happened
//
//  Created by Drew Lanning on 8/31/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
//    UserDefaults().set(false, forKey: "migrated")
//    print(UserDefaults().bool(forKey: "migrated"))
    
    if !UserDefaults().bool(forKey: "migrated") {
      let oldPsc = oldPersistentContainer.persistentStoreCoordinator
      for store in oldPsc.persistentStores {
        if let url = store.url, let oldStore = oldPsc.persistentStore(for: url) {
          if let newURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.drewlanning.It-Happened.todayWidget")?.appendingPathComponent("It_Happened.sqlite") {
            migrate(store: oldStore, from: url, to: newURL)
            try! oldPsc.destroyPersistentStore(at: url, ofType: NSSQLiteStoreType, options: nil)
//            print("migration attempted")
          }
        } else {
//          print("no store found at oldPSC")
        }
      }
    }
    
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    persistentContainer.viewContext.refreshAllObjects()
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    self.saveContext()
  }
  
  // MARK: - Core Data stack
  
  lazy var oldPersistentContainer: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    let container = NSPersistentContainer(name: "It_Happened")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        
        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "It_Happened")
    var persistentStoreDescriptions: NSPersistentStoreDescription
    let storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.drewlanning.It-Happened.todayWidget")?.appendingPathComponent("It_Happened.sqlite")
    let description = NSPersistentStoreDescription()
    description.shouldInferMappingModelAutomatically = true
    description.shouldMigrateStoreAutomatically = true
    description.url = storeURL
    
    container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: storeURL!)]
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  // MARK: - Core Data Saving support
  
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
  func migrate(store: NSPersistentStore, from oldURL: URL, to newURL: URL) {
    let psc = (UIApplication.shared.delegate as! AppDelegate).oldPersistentContainer.persistentStoreCoordinator
    do {
      try psc.migratePersistentStore(store, to: newURL, options: nil, withType: NSSQLiteStoreType)
      try! psc.destroyPersistentStore(at: oldURL, ofType: NSSQLiteStoreType, options: nil)
      UserDefaults().set(true, forKey: "migrated")
    } catch {
//      print("Failed to move from: \(oldURL) to \(newURL)")
    }
  }
  
}

