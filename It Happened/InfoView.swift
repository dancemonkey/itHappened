//
//  InfoView.swift
//  It Happened
//
//  Created by Drew Lanning on 11/12/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit

class InfoView: UIView {
  
  @IBOutlet weak var dateLbl: UILabel!
  @IBOutlet weak var totalLbl: UILabel!
  @IBOutlet weak var average: UILabel!
  @IBOutlet weak var labelStack: UIStackView!
  
  var formatter: DateFormatter!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    formatter = DateFormatter()
    formatter.dateFormat = "MMM d, yyyy"
    styleViews()
  }
  
  func configureSubviews(withActivity activity: Activity, forDate date: Date) {
    for view in labelStack.subviews {
      view.isHidden = false
    }
    dateLbl.text = formatter.string(from: date)
    totalLbl.text = "Total for this day: \(activity.getInstanceCount(forDate: date))"
    average.text = "Historical average: \(activity.getAveragePerDay()) per day"
  }
  
  func hideSubviews() {
    for view in labelStack.subviews {
      view.isHidden = true
    }
  }
  
  func styleViews() {
    self.backgroundColor = .clear
    dateLbl.textColor = .white
    totalLbl.textColor = .white
    average.textColor = .white
  }
  
  func chartIsUpdating(_ updating: Bool) {
    dateLbl.isHidden = !updating
    totalLbl.isHidden = !updating
    if updating {
      dateLbl.text = "UPDATING..."
      totalLbl.text = "Large data sets may take a few moments to load..."
    } else {
      dateLbl.text = ""
      totalLbl.text = ""
    }
  }
  
  func showHint() {
    totalLbl.isHidden = false
    totalLbl.text = "Tap and hold on a bar for more details..."
  }
  
}
