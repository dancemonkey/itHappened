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
  var noteEdited: Bool = false
  
  // TODO: add date/time picker option
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let instanceToEdit = instance {
      timeFld.placeholder = instanceToEdit.getFormattedTime() // extract just time out of this
      noteFld.placeholder = instanceToEdit.note
    }
    
    styleViews()
    
    // load instance data from row tapped in list that brought you here
  }
  
  func styleViews() {
    timeLbl.textColor = Colors.accent2
    noteLbl.textColor = Colors.accent2
    timeFld.backgroundColor = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)
    noteFld.backgroundColor = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)
    timeFld.textColor = .white
    noteFld.textColor = .white
    
    let tapper = UITapGestureRecognizer(target: self, action: #selector(EditInstanceVC.openDatePicker))
    tapper.numberOfTapsRequired = 1
    timeFldOverlay.addGestureRecognizer(tapper)
    
    noteFld.addTarget(self, action: #selector(EditInstanceVC.didEditNote), for: UIControlEvents.editingDidBegin)
  }
  
  func didEditNote() {
    noteEdited = true
  }
  
  @IBAction func updateBtnTapped(sender: BaseButton) {
    // need some data sanitizing here
    if noteFld.text != nil, noteEdited == true {
      instance!.note = noteFld.text!
    }
    let dm = DataManager()
    dm.save()
    navigationController?.popViewController(animated: true)
  }
  
  func openDatePicker() {
    performSegue(withIdentifier: "showDatePicker", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDatePicker" {
      let destVC = segue.destination as? DatePickerVC
      destVC?.delegate = self
      destVC?.dateAndTime = instance!.date! as Date
    }
  }
  
  // MARK: Protocol Functions
  
  func receive(date: Date) {
    instance!.date = date as NSDate
    timeFld.text = instance?.getFormattedTime()
  }
  
}