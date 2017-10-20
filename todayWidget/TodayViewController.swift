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
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
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
  
  var frc: NSFetchedResultsController<Activity>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
    // Perform any setup necessary in order to update the view.
    
    do {
      try frc?.performFetch()
    } catch {
      print("stop trying to make fetch happen")
    }
    
    // If an error is encountered, use NCUpdateResult.Failed
    // If there's no update required, use NCUpdateResult.NoData
    // If there's an update, use NCUpdateResult.NewData
    
    completionHandler(NCUpdateResult.newData)
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
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "created", ascending: true)]
    let fetchedResultsController: NSFetchedResultsController<Activity> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    return fetchedResultsController
  }
  
  // Tableview methods
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return frc?.fetchedObjects?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = (frc?.fetchedObjects![indexPath.row])?.name ?? "No activities fetched"
    return cell
  }
  
}
