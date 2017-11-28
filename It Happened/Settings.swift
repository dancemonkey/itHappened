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
  static let didChangeObject = "didChangeObject"
}

typealias Theme = [ColorSlot: UIColor]

struct Settings {
  
  private var theme: Theme?
  let appGroup: String = "group.com.drewlanning.It-Happened.todayWidget"

  var colorTheme: Theme {
    get {
      guard let theme = UserDefaults.init(suiteName: appGroup)?.value(forKey: SettingsKey.colorTheme) else {
        return ThemeOption.dark
      }
      let savedTheme = ThemeType(rawValue: theme as! String)!
      switch savedTheme {
      case .dark: return ThemeOption.dark
      case .light: return ThemeOption.light
      }
    }
  }
  
  var didChangeObject: Bool {
    return (UserDefaults.init(suiteName: appGroup)?.bool(forKey: SettingsKey.didChangeObject))!
  }
  
  mutating func setColorTheme(to theme: ThemeType) {
    UserDefaults.standard.set(theme.rawValue, forKey: SettingsKey.colorTheme)
    switch theme {
    case .dark: self.theme = ThemeOption.dark
    case .light: self.theme = ThemeOption.light
    }
  }
  
  func getColorThemeName() -> ThemeType {
    guard let theme = UserDefaults.standard.value(forKey: SettingsKey.colorTheme) else {
      return .dark
    }
    return ThemeType(rawValue: theme as! String)!
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
  
  func didChangeObjectOn() {
    UserDefaults.init(suiteName: appGroup)?.set(true, forKey: SettingsKey.didChangeObject)
  }
  
  func didChangeObjectOff() {
    UserDefaults.init(suiteName: appGroup)?.set(false, forKey: SettingsKey.didChangeObject)
  }
  
}
