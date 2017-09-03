//
//  ViewController.swift
//  It Happened
//
//  Created by Drew Lanning on 8/31/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

class ActivityVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
  
  @IBOutlet weak var headingLbl: UILabel!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var newButton: UIButton!
  @IBOutlet weak var helpButton: UIButton!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var emptyDataLbl: UILabel!
    
  fileprivate var frc: NSFetchedResultsController<Activity> = {
    let context = DataManager().context
    let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    let fetchedResultsController: NSFetchedResultsController<Activity> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    fetchedResultsController.delegate = self as? NSFetchedResultsControllerDelegate
    return fetchedResultsController
  }()
    
  override func viewDidLoad() {
    super.viewDidLoad()
    styleViews()
    tableView.delegate = self
    tableView.dataSource = self
    updateView()
  }
  
  func styleViews() {
    headingLbl.textColor = Colors.primary
    self.view.backgroundColor = Colors.black
    tableView.backgroundColor = Colors.black
    newButton.setTitleColor(Colors.accent2, for: .normal)
    helpButton.setTitleColor(Colors.accent1, for: .normal)
    emptyDataLbl.textColor = Colors.accent2
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func newTapped(sender: UIButton) {
    let newActivityPopup = UIAlertController(title: "Create New Activity", message: nil, preferredStyle: .alert)
    let createAction = UIAlertAction(title: "Create", style: .default) { (action: UIAlertAction!) in
      if let nameField = newActivityPopup.textFields?.first, nameField.text != nil, nameField.text != "" {
        // TODO: test against blank text field and enable/disable Create button
        let new = Activity(context: DataManager().context)
        new.name = nameField.text!
        DataManager().save()
//        DataManager().addNewActivity(called: nameField.text!)
      }
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    newActivityPopup.addTextField(configurationHandler: nil)
    newActivityPopup.addAction(createAction)
    newActivityPopup.addAction(cancelAction)
    present(newActivityPopup, animated: true, completion: nil)
    
  }
  
  // MARK: Tableview Functions
  
  func configure(cell: ActivityCell, at indexPath: IndexPath) {
    cell.configureCell(with: frc.object(at: indexPath))
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let activities = frc.fetchedObjects else { return 0 }
    return activities.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell") as! ActivityCell
    configure(cell: cell, at: indexPath)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let incidentVC = storyboard?.instantiateViewController(withIdentifier: "InstanceVC")
    navigationController?.show(incidentVC!, sender: self)
  }
  
  fileprivate func updateView() {
    do {
      try frc.performFetch()
    } catch {
      print("nope")
    }
    var hasActivities = false
    if let activities = frc.fetchedObjects {
      hasActivities = activities.count > 0
    }
    tableView.isHidden = !hasActivities
    emptyDataLbl.isHidden = hasActivities
    activityIndicator.stopAnimating()
  }
  
  // MARK: NSFetchedResultsController Shit
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    print("this has been called")
    tableView.beginUpdates()
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    print("this has also been called")
    tableView.endUpdates()
    updateView()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch (type) {
    case .insert:
      if let indexPath = newIndexPath {
        tableView.insertRows(at: [indexPath], with: .fade)
      }
    default:
      print("default we messed up")
    }
  }
  
  // MARK: Segue functions
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showInstanceList" {
      // DI activity into instanceList VC
    }
  }
  
}

