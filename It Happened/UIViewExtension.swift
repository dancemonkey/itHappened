//
//  BarChartViewExtension.swift
//  It Happened
//
//  Created by Drew Lanning on 11/11/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import Foundation

extension UIView {
  
  var legendLabelWidth: CGFloat {
    return 50
  }
  var labelHeight: CGFloat {
    return 27
  }
  var legendLabel: UILabel {
    return UILabel()
  }
  
  func setLabel(withText text: String) {
    legendLabel.frame = CGRect(x: 0, y: self.bounds.height, width: legendLabelWidth, height: labelHeight)
    legendLabel.adjustsFontSizeToFitWidth = true
    legendLabel.shadowColor = .black
    legendLabel.shadowOffset = CGSize(width: 0, height: 1)
    legendLabel.backgroundColor = .clear
    legendLabel.text = text
    self.addSubview(legendLabel)
  }
  
 func layoutSubviews() {
    let xOffset:CGFloat = self.frame.origin.x
    let yOffset:CGFloat = 0
    let width = self.frame.size.width
    let height = self.labelHeight
    
    self.legendLabel.frame = CGRect(x: xOffset, y: yOffset, width: width, height: height)
  }

}
