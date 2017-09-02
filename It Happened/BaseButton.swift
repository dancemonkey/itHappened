//
//  BaseButton.swift
//  It Happened
//
//  Created by Drew Lanning on 9/2/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit

class BaseButton: UIButton {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.backgroundColor = Colors.primary
    self.setTitleColor(.white, for: .normal)
    self.layer.cornerRadius = 4
    self.layer.masksToBounds = true
  }

}
