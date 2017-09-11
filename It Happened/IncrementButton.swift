//
//  IncrementButton.swift
//  It Happened
//
//  Created by Drew Lanning on 9/10/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit

class IncrementButton: UIButton {
  
  var defaultImage: UIImage = UIImage(named: "+ Button")!
  var checkImage: UIImage = UIImage(named: "Check Button")!
  
  override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  override func awakeFromNib() {
  }
  
  func setCheckImage() {
    setImage(checkImage, for: .normal)
  }
  
  func setDefaultImage() {
    setImage(defaultImage, for: .normal)
  }
  
}
