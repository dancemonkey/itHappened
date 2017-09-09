//
//  NewButton.swift
//  It Happened
//
//  Created by Drew Lanning on 9/9/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit

class NewButton: UIButton {

  override func awakeFromNib() {
    super.awakeFromNib()
    self.backgroundColor = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.3)
    self.setTitleColor(Colors.accent2, for: .normal)
    self.layer.cornerRadius = 4
    self.layer.masksToBounds = true
//    self.layer.borderColor = Colors.accent2.cgColor
//    self.layer.borderWidth = 1.0
  }

}
