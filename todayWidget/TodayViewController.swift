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
  
  // MARK: Properties
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var emptyDataLbl: UILabel!
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
  
  // MARK: Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded

    tableView.dataSource = self
    tableView.delegate = self

    frc = getFrc()

    do {
      try frc?.performFetch()
    } catch {
      print("stop trying to make fetch happen")
    }
    
    updateView()
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
  
  fileprivate func updateView() {
    var hasActivities = false
    if let activities = frc?.fetchedObjects {
      hasActivities = activities.count > 0
    }
    tableView.isHidden = !hasActivities
    emptyDataLbl.isHidden = hasActivities
  }
  
  // MARK: CoreData
  
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
  
  // MARK: Tableview methods
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return frc?.fetchedObjects?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "todayViewCell") as! TodayViewCell
    configure(cell: cell, at: indexPath, withContext: persistentContainer.viewContext)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    print("going back to app")
    if let url: URL = URL(string: "It-Happened://") {
      self.extensionContext?.open(url, completionHandler: nil)
    }
  }
  
  // MARK: Widget Protocol Methods
  
  func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
    switch activeDisplayMode {
    case .expanded:
      let items = frc?.fetchedObjects?.count ?? 0
      preferredContentSize = CGSize(width: 0, height: Int(tableView.rowHeight) * items)
    case .compact:
      preferredContentSize = maxSize
    }
  }
  
}
