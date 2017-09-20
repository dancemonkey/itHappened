//
//  Extensions.swift
//  It Happened
//
//  Created by Drew Lanning on 9/6/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit

extension UIView {
  func pushTransition(_ duration:CFTimeInterval) {
    let animation:CATransition = CATransition()
    animation.timingFunction = CAMediaTimingFunction(name:
      kCAMediaTimingFunctionEaseInEaseOut)
    animation.type = kCATransitionPush
    animation.subtype = kCATransitionFromTop
    animation.duration = duration
    layer.add(animation, forKey: kCATransitionPush)
  }
}

extension UIButton {
  
  func pulsateOut() {
    UIView.animate(withDuration: 0.1) {
      self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
  }
  
  func pulsateIn() {
    UIView.animate(withDuration: 0.1) {
      self.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    }
  }
}
