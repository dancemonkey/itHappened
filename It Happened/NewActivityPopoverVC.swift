//
//  NewActivityPopoverVC.swift
//  It Happened
//
//  Created by Drew Lanning on 9/15/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit

class NewActivityPopoverVC: UIViewController {
  
  @IBOutlet weak var nameFld: UITextField!
  @IBOutlet weak var titleLbl: UILabel!
  
  var completion: ((String) -> ())? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    nameFld.becomeFirstResponder()
    titleLbl.textColor = Colors.primary
    titleLbl.font = UIFont.systemFont(ofSize: 22, weight: .bold)
  }
  
  @IBAction func okPressed(sender: UIButton) {
    if let closure = completion, let name = nameFld.text, name != "" {
      closure(name)
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  @IBAction func cancelPressed(sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
}
