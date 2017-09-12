//
//  ActivityCell.swift
//  It Happened
//
//  Created by Drew Lanning on 9/1/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {
  
  @IBOutlet weak var activityTitleLbl: UILabel!
  @IBOutlet weak var lastIncidentLbl: UILabel!
  @IBOutlet weak var todayTotalLbl: UILabel!
  @IBOutlet weak var todayTotalTimes: UILabel!
  @IBOutlet weak var newIncidentBtn: IncrementButton!
  @IBOutlet weak var animationView: UIView!
  
  var activity: Activity?
  
  func styleViews() {
    activityTitleLbl.textColor = Colors.accent2
    lastIncidentLbl.textColor = Colors.accent1
    todayTotalLbl.textColor = Colors.accent2
    todayTotalTimes.textColor = Colors.accent2
    self.backgroundColor = Colors.black
    newIncidentBtn.tintColor = Colors.accent1
  }
  
  func configureCell(with activity: Activity) {
    self.activity = activity
    activityTitleLbl.text = activity.name
    lastIncidentLbl.text = activity.lastInstance?.getColloquialDateAndTime()
    animationView.pushTransition(1.0)
    todayTotalLbl.text = "\(activity.getTodaysTotal())"
    self.selectionStyle = .none
  }
  
  @IBAction func activityHappened(sender: IncrementButton) {
    UIView.animate(withDuration: 0.0, delay: 0, options: .transitionCrossDissolve, animations: {
      self.newIncidentBtn.setCheckImage()
    }, completion: { finished in
      UIView.animate(withDuration: 0.4, delay: 0.2, animations: {
        self.newIncidentBtn.alpha = 0.0
      }, completion: { (finished) in
        self.newIncidentBtn.setDefaultImage()
        self.newIncidentBtn.alpha = 1.0
        self.activity?.addNewInstance(withContext: DataManager().context)
      })
    })
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    styleViews()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
