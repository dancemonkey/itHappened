//
//  InstanceVC.swift
//  It Happened
//
//  Created by Drew Lanning on 8/31/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

class InstanceVC: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UIPopoverPresentationControllerDelegate {
  
  @IBOutlet weak var newButton: UIButton!
  @IBOutlet weak var tableView: ActivityTableView!
  @IBOutlet weak var emptyDataLbl: UILabel!
  @objc @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  var activity: Activity?
  
  fileprivate lazy var frc: NSFetchedResultsController<Instance> = {
    let dm = DataManager()
    let context = dm.context
    let fetchRequest: NSFetchRequest<Instance> = Instance.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
    let activity = self.activity!
    fetchRequest.predicate = NSPredicate(format: "activity == %@", activity)
    let fetchedResultsController: NSFetchedResultsController<Instance> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "sectionNameFromDate", cacheName: nil)
    return fetchedResultsController
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.setNavigationBarHidden(false, animated: true)
    
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
    newButton.setTitleColor(Colors.accent2, for: .normal)
    self.view.backgroundColor = Colors.black
    tableView.backgroundColor = Colors.black
    self.title = activity?.name!
    emptyDataLbl.textColor = Colors.accent2
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  fileprivate func updateView() {
    var hasInstances = false
    if let instances = frc.fetchedObjects {
      hasInstances = instances.count > 0
    }
    tableView.isHidden = !hasInstances
    emptyDataLbl.isHidden = hasInstances
    activityIndicator.stopAnimating()
  }
  
  @IBAction func newButtonTapped(sender: UIButton) {
    self.activity!.addNewInstance(withContext: DataManager().context)
    DataManager().save()
  }
  
  func setHeader(forSection section: Int) {
    let headerText = self.tableView(tableView, titleForHeaderInSection: section)!
    tableView.headerView(forSection: section)?.textLabel?.text = ""
    tableView.headerView(forSection: section)?.textLabel?.text = headerText
  }
  
  // MARK: Tableview functions
  
  func configure(cell: InstanceCell, at indexPath: IndexPath) {
    cell.configureCell(with: frc.object(at: indexPath))
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    guard let count = frc.sections?.count else {
      return 0
    }
    return count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let sections = frc.sections else {
      fatalError("no sections!")
    }
    let sectionInfo = sections[section]
    return sectionInfo.numberOfObjects
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard let sectionInfo = frc.sections?[section] else {
      fatalError("Unexpected Section")
    }
    let firstInstance = frc.sections![section].objects?.first as! Instance
    return sectionInfo.name + " - \(firstInstance.getInstanceCount(forDate: firstInstance.date! as Date))" + "    "
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "instanceCell") as! InstanceCell
    configure(cell: cell, at: indexPath)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    (tableView as? ActivityTableView)?.selectedInstance = frc.object(at: indexPath)
    performSegue(withIdentifier: "editInstance", sender: self)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
      let vc = self.storyboard?.instantiateViewController(withIdentifier: "deleteConfirmation") as! DeleteConfirmationVC
      vc.modalPresentationStyle = .popover
      vc.completion = {
        let instance = self.frc.object(at: indexPath)
        DataManager().context.delete(instance)
        DataManager().save()
      }
      let popOverPresentationController = vc.popoverPresentationController
      if let popOverPC = popOverPresentationController {
        popOverPC.sourceView = self.view
        popOverPC.delegate = self
        popOverPC.permittedArrowDirections = .init(rawValue: 0)
        popOverPC.sourceRect = self.view.bounds
        self.present(vc, animated: true, completion: nil)
      }
    }
    delete.backgroundColor = Colors.accent3
    return [delete]
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40.0
  }
  
  // MARK: NS FRC Functions
  
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
      if let indexPath = indexPath {
        tableView.reloadRows(at: [indexPath], with: .fade)
        setHeader(forSection: indexPath.section)
      }
    case .insert:
      if let indexPath = newIndexPath {
        tableView.insertRows(at: [indexPath], with: .fade)
        setHeader(forSection: indexPath.section)
      }
    case .move:
      if let indexPath = indexPath {
        tableView.deleteRows(at: [indexPath], with: .fade)
        setHeader(forSection: indexPath.section)
      }
      if let new = newIndexPath {
        tableView.insertRows(at: [new], with: .fade)
        setHeader(forSection: new.section)
      }
    case .delete:
      if let indexPath = indexPath {
        tableView.deleteRows(at: [indexPath], with: .fade)
        if let objects = frc.fetchedObjects, objects.count > 0 {
          setHeader(forSection: indexPath.section)
        }
      }
    }
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    switch type {
    case .insert:
      tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
    case .delete:
      tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
    case .move:
      break
    case .update:
      tableView.reloadSections(IndexSet(integer: sectionIndex), with: .fade)
      setHeader(forSection: sectionIndex)
    }
  }
  
  // MARK: PresentationController delegate
  
  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .none
  }
  
  // MARK: Segue to Editing Instance
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "editInstance", let instance = tableView.selectedInstance {
      let destVC = segue.destination as? EditInstanceVC
      destVC?.instance = instance
    }
  }
  
}
