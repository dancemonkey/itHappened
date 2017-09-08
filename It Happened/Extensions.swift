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
}
