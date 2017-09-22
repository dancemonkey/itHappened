//
//  Settings.swift
//  It Happened
//
//  Created by Drew Lanning on 9/21/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import Foundation

enum SettingsKey {
  static let sound = "sound"
  static let haptic = "haptic"
}

class Settings {
  
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
