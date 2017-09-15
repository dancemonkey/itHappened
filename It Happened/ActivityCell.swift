//
//  ActivityCell.swift
//  It Happened
//
//  Created by Drew Lanning on 9/1/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

class ActivityCell: UITableViewCell {
  
  @IBOutlet weak var activityTitleLbl: UILabel!
  @IBOutlet weak var lastIncidentLbl: UILabel!
  @IBOutlet weak var todayTotalLbl: UILabel!
  @IBOutlet weak var todayTotalTimes: UILabel!
  @IBOutlet weak var newIncidentBtn: IncrementButton!
  @IBOutlet weak var animationView: UIView!
  
  var addNewInstance: (() -> ())?
  var swipe: UISwipeGestureRecognizer?
  
  func styleViews() {
    activityTitleLbl.textColor = Colors.accent2
    lastIncidentLbl.textColor = Colors.accent1
    todayTotalLbl.textColor = Colors.accent2
    todayTotalTimes.textColor = Colors.accent2
    self.backgroundColor = Colors.black
    newIncidentBtn.tintColor = Colors.accent1
  }
  
  func configureCell(with activity: Activity) {
    activityTitleLbl.text = activity.name
    lastIncidentLbl.text = activity.lastInstance?.getColloquialDateAndTime()
    setIncrementCounter(to: activity.getInstanceCount(forDate: Date()))
    addNewInstance = {
      activity.addNewInstance(withContext: DataManager().context)
    }
    self.selectionStyle = .none
  }
  
  func setIncrementCounter(to count: Int) {
    animationView.pushTransition(1.0)
    self.todayTotalLbl.text = "\(count)"
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
        if let addNew = self.addNewInstance {
          addNew()
          DataManager().save()
        }
      })
    })
  }
  
  override func willTransition(to state: UITableViewCellStateMask) {
    if state == .showingDeleteConfirmationMask {
      newIncidentBtn.isUserInteractionEnabled = false
    } else {
      newIncidentBtn.isUserInteractionEnabled = true
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    styleViews()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    print("preparing for re-use")
    print(todayTotalLbl.text)
    todayTotalLbl.text = ""
    print(todayTotalLbl.text)
  }
  
  // MARK: UIGesture methods
  
  override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return true
  }
  
}
