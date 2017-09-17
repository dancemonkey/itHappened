//
//  DeleteConfirmationVC.swift
//  It Happened
//
//  Created by Drew Lanning on 9/16/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit

class DeleteConfirmationVC: UIViewController {

  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var messageLbl: UILabel!
  
  @IBOutlet weak var okButton: BaseButton!
  
  var completion: (() -> ())? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    titleLbl.textColor = Colors.primary
    titleLbl.font = UIFont.systemFont(ofSize: 22, weight: .bold)
    okButton.backgroundColor = Colors.accent3
  }
  
  @IBAction func okPressed(sender: UIButton) {
    if let closure = completion {
      closure()
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  @IBAction func cancelPressed(sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }

}
