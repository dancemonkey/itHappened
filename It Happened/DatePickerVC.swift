//
//  DatePickerVC.swift
//  It Happened
//
//  Created by Drew Lanning on 9/7/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit

class DatePickerVC: UIViewController, UIPickerViewDelegate {
  
  @IBOutlet weak var updateBtn: BaseButton!
  @IBOutlet weak var picker: UIDatePicker!
  
  var delegate: ReceiveDate?
  var dateAndTime: Date?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    picker.setDate(dateAndTime!, animated: true)
    styleViews()
  }
  
  func styleViews() {
    picker.setValue(Colors.accent2, forKey: "textColor")
    picker.maximumDate = Date()
  }
  
  @IBAction func updateTapped(sender: BaseButton) {
    delegate?.receive(date: picker.date)
    navigationController?.popViewController(animated: true)
  }
  
}
