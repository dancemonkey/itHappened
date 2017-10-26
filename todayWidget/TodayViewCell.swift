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
    self.todayTotalLbl.text = "today: \(count)"
  }
  
  func configureCell(with activity: Activity, inContext context: NSManagedObjectContext) {
    self.context = context
    activityTitle.text = activity.name
    setIncrementCounter(to: activity.getInstanceCount(forDate: Date()))
    addNewInstance = { [weak self] in
      activity.addNewInstance(withContext: self!.context!)
      self?.setIncrementCounter(to: activity.getInstanceCount(forDate: Date()))
    }
    self.selectionStyle = .none
  }
  
  @IBAction func activityHappened(sender: IncrementButton) {
    UIView.animate(withDuration: 0.0, delay: 0, options: .transitionCrossDissolve, animations: {
//      self.newIncidentBtn.setCheckImage()
      self.generator.notificationOccurred(.success)
    }, completion: { finished in
      UIView.animate(withDuration: 0.4, delay: 0.2, animations: {
//        self.newIncidentBtn.alpha = 0.0
      }, completion: { (finished) in
//        self.newIncidentBtn.setDefaultImage()
//        self.newIncidentBtn.alpha = 1.0
        if let addNew = self.addNewInstance {
          addNew()
          do {
            try self.context?.save()
          } catch {
            print("could not save to context in today widget")
          }
        }
      })
    })
  }
  
}
