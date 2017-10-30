//
//  TodayViewCell.swift
//  todayWidget
//
//  Created by Drew Lanning on 10/25/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

class TodayViewCell: UITableViewCell {
  
  @IBOutlet weak var activityTitle: UILabel!
  @IBOutlet weak var newIncidentBtn: IncrementButton!
  @IBOutlet weak var todayTotalLbl: UILabel!
  @IBOutlet weak var mostRecentLbl: UILabel!
  
  var addNewInstance: (() -> ())?
  let generator = UINotificationFeedbackGenerator()
  var context: NSManagedObjectContext?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)    
  }
  
  func setIncrementCounter(to count: Int) {
    self.todayTotalLbl.text = "(\(count))"
  }
  
  func setMostRecent(to dateString: String?) {
    mostRecentLbl.text = dateString != nil ? "- " + dateString! : ""
  }
  
  func configureCell(with activity: Activity, inContext context: NSManagedObjectContext) {
    self.context = context
    activityTitle.text = activity.name
    setIncrementCounter(to: activity.getInstanceCount(forDate: Date()))
    setMostRecent(to: activity.lastInstance?.getColloquialDateAndTime())
    addNewInstance = { [weak self] in
      activity.addNewInstance(withContext: self!.context!)
      self?.setIncrementCounter(to: activity.getInstanceCount(forDate: Date()))
      self?.setMostRecent(to: activity.lastInstance?.getColloquialDateAndTime())
    }
    self.selectionStyle = .none
  }
  
  func flashCell() {
    UIView.animate(withDuration: 0, animations: {
      self.contentView.backgroundColor = .white
    }) { (complete) in
      UIView.animate(withDuration: 1.0, animations: {
        self.contentView.backgroundColor = .clear
      })
    }
  }
  
  @IBAction func activityHappened(sender: IncrementButton) {
    UIView.animate(withDuration: 0.0, delay: 0, options: .transitionCrossDissolve, animations: {
      self.generator.notificationOccurred(.success)
    }, completion: { finished in
      if let addNew = self.addNewInstance {
        addNew()
        self.flashCell()
        do {
          try self.context?.save()
        } catch {
          print("could not save to context in today widget")
        }
      }
    })
  }
  
}
