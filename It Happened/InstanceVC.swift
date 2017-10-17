//
//  InstanceVC.swift
//  It Happened
//
//  Created by Drew Lanning on 8/31/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class InstanceVC: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UIPopoverPresentationControllerDelegate, PopoverPresenter, AudioPlayer {
  
  @IBOutlet weak var newButton: UIButton!
  @IBOutlet weak var tableView: ActivityTableView!
  @IBOutlet weak var emptyDataLbl: UILabel!
  @objc @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  var activity: Activity?
  var generator = UINotificationFeedbackGenerator()
  var audioPlayer: AVAudioPlayer?
  
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
    
    setupAudioSession()
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
    newButton.setTitleColor(Settings().colorTheme[.accent2], for: .normal)
    self.view.backgroundColor = Settings().colorTheme[.background]
    tableView.backgroundColor = Settings().colorTheme[.background]
    self.title = activity?.name!
    emptyDataLbl.textColor = Settings().colorTheme[.accent2]
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.prefersLargeTitles = true
    
    tableView.animateViews(animationType: Animations.tableRowsIn)
    newButton.animate(animationType: Animations.newButtonIn)
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
    playSound(called: Sound.numberRise)
    generator.notificationOccurred(.success)
    DataManager().save()
  }
  
  func setHeader(forSection section: Int) {
    let headerText = self.tableView(tableView, titleForHeaderInSection: section)!
    tableView.headerView(forSection: section)?.textLabel?.text = ""
    tableView.headerView(forSection: section)?.textLabel?.text = headerText
    tableView.reloadData()
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
    let cell = tableView.dequeueReusableCell(withIdentifier: CellIDs.instanceCell) as! InstanceCell
    configure(cell: cell, at: indexPath)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    (tableView as? ActivityTableView)?.selectedInstance = frc.object(at: indexPath)
    performSegue(withIdentifier: SegueIDs.editInstance, sender: self)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
      let vc = self.deleteConfirmation(forObject: self.frc.object(at: indexPath), isActivity: false)
      let popOverPresentationController = vc.popoverPresentationController
      if let popOverPC = popOverPresentationController {
        popOverPC.sourceView = self.view
        popOverPC.delegate = self
        popOverPC.permittedArrowDirections = .init(rawValue: 0)
        popOverPC.sourceRect = self.view.bounds
        self.present(vc, animated: true, completion: nil)
      }
    }
    delete.backgroundColor = Settings().colorTheme[.accent3]
    return [delete]
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40.0
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    for view in headerView.subviews {
      view.removeFromSuperview()
    }
    headerView.backgroundColor = Settings().colorTheme[.primary]
    
    let title = UILabel()
    title.frame = CGRect(x: 8, y: 0, width: tableView.frame.width, height: 40)
    title.textColor = UIColor.white
    title.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
    title.text = (self.tableView(tableView, titleForHeaderInSection: section))?.uppercased()
    title.baselineAdjustment = .alignCenters
    
    headerView.addSubview(title)
    return headerView
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
        var resetHeader = false
        if frc.sections != nil {
          let count = tableView.numberOfRows(inSection: indexPath.section)
          if count > 1 {
            resetHeader = true
          }
        }
        tableView.deleteRows(at: [indexPath], with: .fade)
        if resetHeader {
          setHeader(forSection: indexPath.section)
        }
      }
      if let new = newIndexPath {
        tableView.insertRows(at: [new], with: .fade)
        setHeader(forSection: new.section)
      }
    case .delete:
      if let indexPath = indexPath {
        tableView.deleteRows(at: [indexPath], with: .fade)
        if let sections = frc.sections {
          if sections.count == indexPath.section + 1 {
            setHeader(forSection: indexPath.section)
          }
        }
      }
    }
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    switch type {
    case .insert:
      tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
      setHeader(forSection: sectionIndex)
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
    if segue.identifier == SegueIDs.editInstance, let instance = tableView.selectedInstance {
      let destVC = segue.destination as? EditInstanceVC
      destVC?.instance = instance
    }
  }
  
}
