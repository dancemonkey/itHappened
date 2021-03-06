//
//  Styles.swift
//  It Happened
//
//  Created by Drew Lanning on 8/31/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit

enum ColorSlot {
  case background, primary, secondary, accent1, accent2, accent3, navElement, textField
}

enum ThemeOption {
  static let dark: [ColorSlot: UIColor] = [
    .background: UIColor(red: 10/255, green: 30/255, blue: 35/255, alpha: 1.0),
    .primary: UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0),
    .secondary: UIColor(red: 242/255, green: 193/255, blue: 78/255, alpha: 1.0),
    .accent1: UIColor(red: 95/255, green: 173/255, blue: 86/255, alpha: 1.0),
    .accent2: UIColor(red: 247/255, green: 129/255, blue: 84/255, alpha: 1.0),
    .accent3: UIColor(red: 180/255, green: 67/255, blue: 108/255, alpha: 1.0),
    .navElement: .white,
    .textField: .white
  ]
  static let light: [ColorSlot: UIColor] = [
    .background: UIColor.white,
    .primary: UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0),
    .secondary: UIColor(red: 242/255, green: 193/255, blue: 78/255, alpha: 1.0),
    .accent1: UIColor(red: 95/255, green: 173/255, blue: 86/255, alpha: 1.0),
    .accent2: UIColor(red: 247/255, green: 129/255, blue: 84/255, alpha: 1.0),
    .accent3: UIColor(red: 180/255, green: 67/255, blue: 108/255, alpha: 1.0),
    .navElement: UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0),
    .textField: UIColor.black.withAlphaComponent(0.8)
  ]
}

enum ThemeType: String {
  case dark
  case light
}

enum Sound {
  static let numberRise = "techy_affirm.wav"
  static let buttonPress = "analogue_click.wav"
  static let plusNewPressed = "analogue_click.wav"
  static let deletePopover = "click_alert.wav"
}

enum ImageName {
  static let plusButton = "+ Button"
  static let checkButton = "Check Button"
  static let newButton = "New Button"
}

enum PopupMessages {
  static let deleteTitle = "Are You Sure?"
  static let deleteMessage = "This can't be undone."
  static let newActivityTitle = "Create New Activity"
  static let updateActivityTitle = "Update Activity"
}

enum SegueIDs {
  static let showInstanceList = "showInstanceList"
  static let editInstance = "editInstance"
  static let showDatePicker = "showDatePicker"
  static let showChart = "showChart"
}

enum CellIDs {
  static let activityCell = "activityCell"
  static let instanceCell = "instanceCell"
}
