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
    self.layer.masksToBounds = true
    
    self.layer.shadowColor = UIColor.white.cgColor
    self.layer.shadowOffset = CGSize(width: 0, height: -3)
    self.layer.shadowOpacity = 0
    self.layer.shadowRadius = 3
    
    self.layer.cornerRadius = self.frame.height / 2
  }

}
