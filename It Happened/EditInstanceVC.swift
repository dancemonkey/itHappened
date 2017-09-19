//
//  EditInstanceVC.swift
//  It Happened
//
//  Created by Drew Lanning on 9/2/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit

class EditInstanceVC: UIViewController, ReceiveDate {
  
  @IBOutlet weak var timeLbl: UILabel!
  @IBOutlet weak var noteLbl: UILabel!
  @IBOutlet weak var timeFld: UITextField!
  @IBOutlet weak var noteFld: UITextField!
  @IBOutlet weak var timeFldOverlay: UIView!
  @IBOutlet weak var updateBtn: BaseButton!
  
  var instance: Instance?
  
  // TODO: add date/time picker option
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let instanceToEdit = instance {
      timeFld.text = instanceToEdit.getFormattedTime() // extract just time out of this
      noteFld.text = instanceToEdit.note
    }
    
    styleViews()    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  func styleViews() {
    timeLbl.textColor = Colors.accent2
    noteLbl.textColor = Colors.accent2
    timeFld.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)
    noteFld.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)
    timeFld.textColor = .white
    noteFld.textColor = .white
    
    let tapper = UITapGestureRecognizer(target: self, action: #selector(EditInstanceVC.openDatePicker))
    tapper.numberOfTapsRequired = 1
    timeFldOverlay.addGestureRecognizer(tapper)
  }
  
  @IBAction func updateBtnTapped(sender: BaseButton) {
    instance!.note = noteFld.text!
    let dm = DataManager()
    dm.save()
    navigationController?.popViewController(animated: true)
  }
  
  @objc func openDatePicker() {
    performSegue(withIdentifier: SegueIDs.showDatePicker, sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == SegueIDs.showDatePicker {
      let destVC = segue.destination as? DatePickerVC
      destVC?.delegate = self
      destVC?.dateAndTime = instance!.date! as Date
    }
  }
  
  // MARK: Protocol Functions
  
  func receive(date: Date) {
    instance!.date = date as NSDate
    timeFld.text = instance?.getFormattedTime()
    let dm = DataManager()
    dm.save()
  }
  
}
