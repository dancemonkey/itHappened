//
//  TodayViewController.swift
//  todayWidget
//
//  Created by Drew Lanning on 10/20/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  var activities: [Activity]?
  
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
    container.viewContext.stalenessInterval = 0
    return container
  }()
  
  var frc: NSFetchedResultsController<Activity>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(TodayViewController.managedObjectContextDidSave), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)

    tableView.dataSource = self
    tableView.delegate = self
    
    frc = getFrc()
    
    do {
      try frc?.performFetch()
    } catch {
      print("stop trying to make fetch happen")
    }    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
    do {
      try frc?.performFetch()
    } catch {
      print("stop trying to make fetch happen")
    }
    completionHandler(NCUpdateResult.newData)
  }
  
  func configure(cell: TodayViewCell, at indexPath: IndexPath, withContext context: NSManagedObjectContext) {
    cell.configureCell(with: frc!.object(at: indexPath), inContext: context)
  }
  
  // CoreData
  
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        print("did not save, error")
      }
    }
  }
  
  func getFrc() -> NSFetchedResultsController<Activity> {
    let context = persistentContainer.viewContext
    let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sortOrder", ascending: true),NSSortDescriptor(key: "created", ascending: true)]
    let fetchedResultsController: NSFetchedResultsController<Activity> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    return fetchedResultsController
  }
  
  @objc func managedObjectContextDidSave(notification: Notification) {
    
  }
  
  // Tableview methods
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let count = frc?.fetchedObjects?.count ?? 0
    return count <= 3 ? count : 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "todayViewCell") as! TodayViewCell
    configure(cell: cell, at: indexPath, withContext: persistentContainer.viewContext)
    return cell
  }
  
}
