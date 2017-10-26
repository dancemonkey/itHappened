//
//  ViewController.swift
//  It Happened
//
//  Created by Drew Lanning on 8/31/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import ViewAnimator

class ActivityVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UIPopoverPresentationControllerDelegate, PopoverPresenter, AudioPlayer {
  
  @IBOutlet weak var tableView: ActivityTableView!
  @IBOutlet weak var newButton: NewButton!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var emptyDataLbl: UILabel!
  @IBOutlet weak var themeSwitch: UISwitch!
  
  var audioPlayer: AVAudioPlayer?
  var generator = UINotificationFeedbackGenerator()
  var settings = Settings()
  var longPress: UILongPressGestureRecognizer?
  var snapshot: UIView? = nil
  var sourceIndexPath: IndexPath? = nil
  var isUserDrivenUpate: Bool = false
  
  var frc: NSFetchedResultsController<Activity>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    frc = initializeFRC()
    setupAudioSession()
    NotificationCenter.default.addObserver(self, selector: #selector(ActivityVC.appBecameActive), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(ActivityVC.managedObjectContextDidSave), name: NSNotification.Name.NSManagedObjectContextDidSave, object: DataManager().context)
    tableView.delegate = self
    tableView.dataSource = self
    frc.delegate = self
    do {
      try frc.performFetch()
    } catch {
      print("nope")
    }
    updateView()
    themeSwitch.setOn(settings.getColorThemeName() == .dark, animated: false)
    styleViews()
    longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressStarted(sender:)))
    view.addGestureRecognizer(longPress!)
  }
  
  func initializeFRC() -> NSFetchedResultsController<Activity> {
    let dm = DataManager()
    let context = dm.context
    let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sortOrder", ascending: true), NSSortDescriptor(key: "created", ascending: true)]
    let fetchedResultsController: NSFetchedResultsController<Activity> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    return fetchedResultsController
  }
  
  @objc func longPressStarted(sender: UILongPressGestureRecognizer) {
    let state = sender.state
    let location = sender.location(in: self.tableView)
    let indexPath = tableView.indexPathForRow(at: location)
    
    switch state {
    case .began:
      if indexPath != nil {
        sourceIndexPath = indexPath
        let cell = self.tableView.cellForRow(at: indexPath!)!
        snapshot = customSnapshotFromView(inputView: cell)
        var center = cell.center
        snapshot!.center = center
        snapshot!.alpha = 0.0
        tableView.addSubview(snapshot!)
        
        UIView.animate(withDuration: 0.25, animations: {
          center.y = location.y
          self.snapshot!.center = center
          self.snapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
          self.snapshot!.alpha = 0.98
          
          cell.alpha = 0.0
        }, completion: { (finished) in
          cell.isHidden = true
        })
      }
    case .changed:
      var center = snapshot!.center
      center.y = location.y
      snapshot!.center = center
      if indexPath != nil && !(indexPath! == sourceIndexPath!) {
        tableView.moveRow(at: sourceIndexPath!, to: indexPath!)
        
        isUserDrivenUpate = true
        var objects = frc.fetchedObjects!
        let object = objects.remove(at: sourceIndexPath!.row)
        objects.insert(object, at: indexPath!.row)
        
        var i = 0
        for object in objects {
          object.sortOrder = Int32(i)
          i = i + 1
        }
        DataManager().save()
        isUserDrivenUpate = false
        
        sourceIndexPath = indexPath
      }
    default:
      let cell = tableView.cellForRow(at: sourceIndexPath!)
      cell?.isHidden = false
      cell?.alpha = 0.0
      UIView.animate(withDuration: 0.25, animations: {
        self.snapshot!.center = cell!.center
        self.snapshot!.transform = CGAffineTransform.identity
        self.snapshot!.alpha = 0.0
        cell?.alpha = 1.0
      }, completion: { (finished) in
        self.sourceIndexPath = nil
        self.snapshot?.removeFromSuperview()
        self.snapshot = nil
      })
    }
  }
  
  func customSnapshotFromView(inputView: UIView) -> UIView {
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
    inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    let snapshot = UIImageView.init(image: image)
    snapshot.layer.masksToBounds = false
    snapshot.layer.cornerRadius = 0.0
    snapshot.layer.shadowRadius = 5.0
    snapshot.layer.shadowOffset = CGSize(width: -5, height: -0)
    snapshot.layer.shadowOpacity = 0.4
    
    return snapshot
  }
  
  func styleViews() {
    self.view.backgroundColor = Settings().colorTheme[.background]
    tableView.backgroundColor = Settings().colorTheme[.background]
    emptyDataLbl.textColor = Settings().colorTheme[.accent2]
    newButton.tintColor = Settings().colorTheme[.primary]
    
    navigationController?.navigationBar.tintColor = Settings().colorTheme[.navElement]
    UINavigationBar.appearance().barTintColor = Settings().colorTheme[.accent1]
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: Settings().colorTheme[.navElement]!]
    navigationController?.navigationBar.barTintColor = Settings().colorTheme[.background]
    
    switch settings.getColorThemeName() {
    case .dark:
      UIApplication.shared.statusBarStyle = .lightContent
    case .light:
      UIApplication.shared.statusBarStyle = .default
    }
    
    themeSwitch.onTintColor = Settings().colorTheme[.accent1]
    themeSwitch.alpha = 0.3
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
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: Settings().colorTheme[.primary] as Any]
    UINavigationBar.appearance().barTintColor = Settings().colorTheme[.accent1]
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: Settings().colorTheme[.navElement]!]
    navigationController?.navigationBar.barTintColor = Settings().colorTheme[.background]
    tableView.reloadData()
    
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d, yyyy"
    self.title = formatter.string(from: Date())
    
    newButton.animate(animationType: Animations.newButtonIn)
    tableView.animateViews(animationType: Animations.tableRowsIn)
  }
  
  @objc func appBecameActive() {
    if let lastOpen = DataManager().getLastOpen() {
      let formatter = DateFormatter()
      formatter.dateFormat = "EEEE, MMM d, yyyy"
      if formatter.string(from: Date()) != lastOpen {
        DataManager().setLastOpen()
        tableView.reloadData()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        self.title = formatter.string(from: Date())
      }
    } else {
      DataManager().setLastOpen()
    }
  }
  
  @IBAction func newPressed(sender: UIButton) {
    playSound(called: Sound.buttonPress)
    let popOver = activityCreateAndUpdate(withActivity: nil)
    popOver.popoverPresentationController!.delegate = self
    popOver.popoverPresentationController?.permittedArrowDirections = .init(rawValue: 0)
    popOver.popoverPresentationController?.sourceView = self.view
    popOver.popoverPresentationController?.sourceRect = self.view.bounds
    generator.notificationOccurred(.success)
    
    self.present(popOver, animated: true, completion: nil)
  }
  
  @IBAction func themeSwitched(sender: UISwitch) {
    let theme: ThemeType = sender.isOn ? .dark : .light
    settings.setColorTheme(to: theme)
    styleViews()
    for cell in tableView.visibleCells {
      (cell as! ActivityCell).styleViews()
    }
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
    if let cell = tableView.dequeueReusableCell(withIdentifier: CellIDs.activityCell) as? ActivityCell {
      configure(cell: cell, at: indexPath)
      return cell
    }
    return ActivityCell()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    (tableView as? ActivityTableView)?.selectedActivity = frc.object(at: indexPath)
    performSegue(withIdentifier: SegueIDs.showInstanceList, sender: self)
  }
  
  func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let edit = UITableViewRowAction(style: .normal, title: "Edit    ") { (action, index) in
      let vc = self.activityCreateAndUpdate(withActivity: self.frc.object(at: indexPath))
      let popOverPresentationController = vc.popoverPresentationController
      if let popOverPC = popOverPresentationController {
        popOverPC.sourceView = self.view
        popOverPC.delegate = self
        popOverPC.permittedArrowDirections = .init(rawValue: 0)
        popOverPC.sourceRect = self.view.bounds
        self.present(vc, animated: true, completion: nil)
      }
    }
    let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
      let vc = self.deleteConfirmation(forObject: self.frc.object(at: indexPath), isActivity: true)
      let popOverPresentationController = vc.popoverPresentationController
      if let popOverPC = popOverPresentationController {
        popOverPC.sourceView = self.view
        popOverPC.delegate = self
        popOverPC.permittedArrowDirections = .init(rawValue: 0)
        popOverPC.sourceRect = self.view.bounds
        self.present(vc, animated: true, completion: nil)
      }
    }
    let info = UITableViewRowAction(style: .normal, title: "Info    ") { (action, index) in
      let vc = self.activityInfo(forActivity: self.frc.object(at: indexPath))
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
    info.backgroundColor = Settings().colorTheme[.accent1]
    return [info, edit, delete]
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  // MARK: NSFetchedResultsController
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
    updateView()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    guard isUserDrivenUpate == false else {
      return
    }
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
    case .move:
      if let indexPath = indexPath, let newIndexPath = newIndexPath {
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.insertRows(at: [newIndexPath], with: .fade)
      }
    }
  }
  
  @objc func managedObjectContextDidSave(notification: Notification) {
    print("context saved")
  }
  
  // MARK: PresentationController delegate
  
  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .none
  }
  
  // MARK: Segue functions
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == SegueIDs.showInstanceList, let activity = tableView.selectedActivity {
      let destVC = segue.destination as? InstanceVC
      destVC?.activity = activity
    }
  }
}

