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
  
  private var theme: Theme?
  
  var colorTheme: Theme {
    get {
      guard let _ = UserDefaults.standard.value(forKey: SettingsKey.colorTheme) else {
        return ThemeOption.dark
      }
      return self.theme!
    }
  }
  
  mutating func setColorTheme(to theme: Theme) {
    UserDefaults.standard.set(theme, forKey: SettingsKey.colorTheme)
    self.theme = theme
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
