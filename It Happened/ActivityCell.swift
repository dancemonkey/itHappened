//
//  ActivityCell.swift
//  It Happened
//
//  Created by Drew Lanning on 9/1/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class ActivityCell: UITableViewCell, AudioPlayer {
  
  var audioPlayer: AVAudioPlayer?
  
  @IBOutlet weak var activityTitleLbl: UILabel!
  @IBOutlet weak var lastIncidentLbl: UILabel!
  @IBOutlet weak var todayTotalLbl: UILabel!
  @IBOutlet weak var todayTotalTimes: UILabel!
  @IBOutlet weak var newIncidentBtn: IncrementButton!
  @IBOutlet weak var animationView: UIView!
  
  var addNewInstance: (() -> ())?
  var swipe: UISwipeGestureRecognizer?
  let generator = UINotificationFeedbackGenerator()
  
  func styleViews() {
    activityTitleLbl.textColor = Settings().colorTheme[.accent2]
    lastIncidentLbl.textColor = Settings().colorTheme[.accent1]
    todayTotalLbl.textColor = Settings().colorTheme[.accent2]
    todayTotalTimes.textColor = Settings().colorTheme[.accent2]
    self.backgroundColor = Settings().colorTheme[.background]
    newIncidentBtn.tintColor = Settings().colorTheme[.accent1]
  }
  
  func configureCell(with activity: Activity) {
    activityTitleLbl.text = activity.name
    lastIncidentLbl.text = activity.lastInstance?.getColloquialDateAndTime()
    setIncrementCounter(to: activity.getInstanceCount(forDate: Date()))
    addNewInstance = { [weak self] in
      activity.addNewInstance(withContext: DataManager().context)
      self?.playSound(called: Sound.numberRise)
    }
    self.selectionStyle = .none
  }
  
  func setIncrementCounter(to count: Int) {
    self.todayTotalLbl.text = "\(count)"
  }
  
  @IBAction func activityHappened(sender: IncrementButton) {
    UIView.animate(withDuration: 0.0, delay: 0, options: .transitionCrossDissolve, animations: {
      self.newIncidentBtn.setCheckImage()
      self.generator.notificationOccurred(.success)
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
    styleViews()
  }
  
  // MARK: UIGesture methods
  
  override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return true
  }
  
}
