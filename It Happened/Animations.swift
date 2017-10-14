//
//  Animations.swift
//  It Happened
//
//  Created by Drew Lanning on 10/14/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import Foundation
import ViewAnimator

struct Animations {
  static let newButtonIn = AnimationType.from(direction: .right, offset: 60.0)
  static let tableRowsIn = AnimationType.from(direction: .bottom, offset: 200.0)
  static let popOverIn = AnimationType.from(direction: .bottom, offset: 10.0)
}
