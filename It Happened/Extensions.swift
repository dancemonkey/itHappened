//
//  Extensions.swift
//  It Happened
//
//  Created by Drew Lanning on 9/6/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit


extension UIAlertController {
  static func deleteAlert(confirmation: @escaping () -> ()) -> UIAlertController {
    let confirm = UIAlertAction(title: "OK", style: .destructive, handler: { action in 
      confirmation()
    })
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let controller = UIAlertController(title: "Are you sure?", message: "You are about to delete this!", preferredStyle: .actionSheet)
    controller.addAction(confirm)
    controller.addAction(cancel)
    return controller
  }
  
  static func newActivity(confirmation: @escaping (_ name: String) -> ()) -> UIAlertController {
    let controller = UIAlertController(title: "Create new acvitity", message: nil, preferredStyle: .alert)
    controller.addTextField(configurationHandler: nil)
    controller.textFields?.first?.placeholder = "Name of activity"
    
    let confirm = UIAlertAction(title: "Create", style: .destructive, handler: { action in
      if let nameField = controller.textFields?.first, nameField.text != nil, nameField.text != "" {
        confirmation(nameField.text!)
      }
    })
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    controller.addAction(confirm)
    controller.addAction(cancel)
    return controller
  }
  
  static func updateActivity(called name: String, confirmation: @escaping (_ newName: String) -> ()) -> UIAlertController {
    let controller = UIAlertController(title: "Update activity name", message: nil, preferredStyle: .alert)
    controller.addTextField(configurationHandler: nil)
    controller.textFields?.first?.text = name
    
    let confirm = UIAlertAction(title: "Update", style: .default) { action in
      if let nameField = controller.textFields?.first, nameField.text != nil, nameField.text != "" {
        confirmation(nameField.text!)
      }
    }
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    controller.addAction(confirm)
    controller.addAction(cancel)
    return controller
  }
}

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
