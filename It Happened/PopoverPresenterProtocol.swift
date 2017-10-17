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
  func activityCreateAndUpdate(withActivity activity: Activity?) -> NewActivityPopoverVC
}

public extension PopoverPresenter {
  
  func activityInfo(forActivity activity: Activity) -> ActivityInfoVC {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "activityInfoPopover") as! ActivityInfoVC
    vc.modalPresentationStyle = .popover
    vc.activity = activity
    return vc
  }
  
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
  
  func activityCreateAndUpdate(withActivity activity: Activity?) -> NewActivityPopoverVC {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "newActivityPopover") as! NewActivityPopoverVC
    vc.modalPresentationStyle = .popover
    if let existingActivity = activity {
      vc.activity = existingActivity
    }
    vc.completion = { name in
      if activity != nil {
        activity!.name = name
      } else {
        DataManager().addNewActivity(called: name)
      }
      DataManager().save()
    }
    return vc
  }
}
