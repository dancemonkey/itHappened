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
  let generator = UINotificationFeedbackGenerator()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    picker.setDate(dateAndTime!, animated: true)
    styleViews()
  }
  
  func styleViews() {
    picker.setValue(Settings().colorTheme[.accent2], forKey: "textColor")
    picker.maximumDate = Date()
    navigationController?.navigationBar.prefersLargeTitles = false
  }
  
  @IBAction func updateTapped(sender: BaseButton) {
    delegate?.receive(date: picker.date)
    generator.notificationOccurred(.success)
    navigationController?.popViewController(animated: true)
  }
  
}
