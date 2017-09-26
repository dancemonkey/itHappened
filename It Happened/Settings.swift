//
//  Settings.swift
//  It Happened
//
//  Created by Drew Lanning on 9/21/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit

enum SettingsKey {
  static let sound = "sound"
  static let haptic = "haptic"
  static let colorTheme = "colorTheme"
}

typealias Theme = [ColorSlot: UIColor]

struct Settings {
  
  func setColorTheme(to theme: Theme) {
    UserDefaults.standard.set(theme, forKey: SettingsKey.colorTheme)
  }
  
  func getColorTheme() -> Theme {
    if let theme = UserDefaults.standard.value(forKey: SettingsKey.colorTheme) {
      return theme as! Theme
    } else {
      return ThemeOption.dark
    }
  }
  
  func isSoundOn() -> Bool {
    return UserDefaults.standard.bool(forKey: SettingsKey.sound)
  }
  
  func isHapticOn() -> Bool {
    return UserDefaults.standard.bool(forKey: SettingsKey.haptic)
  }
  
  func toggleSound() {
    if isSoundOn() {
      UserDefaults.standard.set(false, forKey: SettingsKey.sound)
    } else {
      UserDefaults.standard.set(true, forKey: SettingsKey.sound)
    }
  }
  
  func toggleHaptic() {
    if isHapticOn() {
      UserDefaults.standard.set(false, forKey: SettingsKey.haptic)
    } else {
      UserDefaults.standard.set(true, forKey: SettingsKey.haptic)
    }
  }
  
  func turnSoundOn() {
    UserDefaults.standard.set(true, forKey: SettingsKey.sound)
  }
  
  func turnHapticOn() {
    UserDefaults.standard.set(true, forKey: SettingsKey.haptic)
  }
  
}
