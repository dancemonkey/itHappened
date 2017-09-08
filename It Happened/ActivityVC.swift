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
  @IBOutlet weak var tableView: ActivityTableView!
  @IBOutlet weak var newButton: UIButton!
  @IBOutlet weak var helpButton: UIButton!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var emptyDataLbl: UILabel!
  
  fileprivate var frc: NSFetchedResultsController<Activity> = {
    let dm = DataManager()
    let context = dm.context
    let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "created", ascending: true)]
    let fetchedResultsController: NSFetchedResultsController<Activity> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    return fetchedResultsController
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    styleViews()
    tableView.delegate = self
    tableView.dataSource = self
    frc.delegate = self
    do {
      try frc.performFetch()
    } catch {
      print("nope")
    }
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
  
  fileprivate func updateView() {
    var hasActivities = false
    if let activities = frc.fetchedObjects {
      hasActivities = activities.count > 0
    }
    tableView.isHidden = !hasActivities
    emptyDataLbl.isHidden = hasActivities
    activityIndicator.stopAnimating()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func newTapped(sender: UIButton) {
    let newActivity = UIAlertController.newActivity { name in
      DataManager().addNewActivity(called: name)
    }
    present(newActivity, animated: true, completion: nil)
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
    (tableView as? ActivityTableView)?.selectedActivity = frc.object(at: indexPath)
    performSegue(withIdentifier: "showInstanceList", sender: self)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, index) in
      let update = UIAlertController.updateActivity(called: self.frc.object(at: index).name!, confirmation: { newName in
        self.frc.object(at: index).name = newName
        DataManager().save()
      })
      self.present(update, animated: true, completion: nil)
    }
    let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
      // now I have to manually handle delete action
      let confirmation = UIAlertController.deleteAlert {
        let activity = self.frc.object(at: indexPath)
        activity.deleteAllInstances()
        self.frc.managedObjectContext.delete(activity)
        let dm = DataManager()
        dm.save()
      }
      self.present(confirmation, animated: true, completion: nil)
    }
    return [delete, edit]
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  // MARK: NSFetchedResultsController Shit
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
    updateView()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch (type) {
    case .update:
      tableView.reloadRows(at: [indexPath!], with: .fade)
    case .insert:
      if let indexPath = newIndexPath {
        tableView.insertRows(at: [indexPath], with: .fade)
      }
    case .delete:
      if let indexPath = indexPath {
        tableView.deleteRows(at: [indexPath], with: .fade)
      }
    default:
      print("default we messed up")
    }
  }
  
  // MARK: Segue functions
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showInstanceList", let activity = tableView.selectedActivity {
      let destVC = segue.destination as? InstanceVC
      destVC?.activity = activity
    }
  }
  
}

