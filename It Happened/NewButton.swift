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
    self.backgroundColor = Colors.accent1.withAlphaComponent(0.3)
    self.backgroundColor?.withAlphaComponent(0.3)
    self.setTitleColor(Colors.accent2, for: .normal)
    self.layer.cornerRadius = 4
    self.layer.masksToBounds = true
    self.layer.shadowColor = Colors.accent2.cgColor
    self.layer.shadowOffset = CGSize(width: 0, height: -3)
    self.layer.shadowOpacity = 0
    self.layer.shadowRadius = 3
  }

}
