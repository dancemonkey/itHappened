//
//  EditInstanceVC.swift
//  It Happened
//
//  Created by Drew Lanning on 9/2/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit

class EditInstanceVC: UIViewController {
  
  @IBOutlet weak var timeLbl: UILabel!
  @IBOutlet weak var noteLbl: UILabel!
  @IBOutlet weak var timeFld: UITextField!
  @IBOutlet weak var noteFld: UITextField!
  @IBOutlet weak var updateBtn: BaseButton!
  
  var instance: Instance?
  
  // TODO: add date/time picker option
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let instanceToEdit = instance {
      timeFld.placeholder = instanceToEdit.getFormattedTime() // extract just time out of this
      // tap field to bring up date and time picker
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
  }
  
  @IBAction func updateBtnTapped(sender: BaseButton) {
    // update edited instance and return to instance table view
  }
  
}
