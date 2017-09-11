//
//  IncrementButton.swift
//  It Happened
//
//  Created by Drew Lanning on 9/10/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit

class IncrementButton: UIButton {
  
  var image1: UIImage = UIImage(named: "+ Button")!
  var image2: UIImage = UIImage(named: "Check Button")!
  
  override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  override func awakeFromNib() {
//    self.setImage(image1, for: .normal)
  }
  
  func checkImage() {
    setImage(image2, for: .normal)
  }
  
  func defaultImage() {
    setImage(image1, for: .normal)
  }
  
}
