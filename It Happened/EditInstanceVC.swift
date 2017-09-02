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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    styleViews()
  }
  
  func styleViews() {
    timeLbl.textColor = Colors.accent2
    noteLbl.textColor = Colors.accent2
  }
  
}
