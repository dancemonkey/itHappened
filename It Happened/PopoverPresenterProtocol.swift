//
//  PopoverPresenterProtocol.swift
//  It Happened
//
//  Created by Drew Lanning on 9/18/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

public protocol PopoverPresenter {
  func deleteConfirmation(forObject object: NSManagedObject, isActivity: Bool) -> DeleteConfirmationVC
  func activityCreateAndUpdate() -> NewActivityPopoverVC
}

public extension PopoverPresenter {
  func deleteConfirmation(forObject object: NSManagedObject, isActivity: Bool) -> DeleteConfirmationVC {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "deleteConfirmation") as! DeleteConfirmationVC
    vc.modalPresentationStyle = .popover
    vc.completion = {
      if isActivity {
        let activity = object as! Activity
        activity.deleteAllInstances()
      }
      DataManager().context.delete(object)
      DataManager().save()
    }
    return vc
  }
  
  func activityCreateAndUpdate() -> NewActivityPopoverVC {
    return NewActivityPopoverVC()
  }
}
