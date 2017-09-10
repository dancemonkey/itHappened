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
//  var imageAlpha: CGFloat = 1.0 {
//    didSet {
//      if let imageView = imageView {
//        imageView.alpha = imageAlpha
//      }
//    }
//  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
//    if let imageView = imageView {
//      imageView.alpha = imageAlpha
//    }
  }
  
  override func awakeFromNib() {
    self.setImage(image1, for: .normal)
  }
  
  func animateImageChange() {
    UIView.animate(withDuration: 10.0) {
      self.alpha = 0.0
    }
  }
  
}
