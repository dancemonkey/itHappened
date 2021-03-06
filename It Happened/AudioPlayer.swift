//
//  AudioPlayer.swift
//  It Happened
//
//  Created by Drew Lanning on 9/19/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import AVFoundation
import UIKit

public protocol AudioPlayer: class {
  var audioPlayer: AVAudioPlayer? { get set }
  func playSound(called sound: String)
  func setupAudioSession()
}

public extension AudioPlayer {
  
  func setupAudioSession() {
    let session = AVAudioSession.sharedInstance()
    do {
      try session.setCategory(AVAudioSessionCategoryAmbient, with: .mixWithOthers)
      try session.setActive(true)
    } catch {
      print("av audio session duck others attempt failed")
    }
  }
  
  func playSound(called sound: String) {
    
    guard Settings().isSoundOn() else {
      return
    }
    
    let audioFilePath = Bundle.main.path(forResource: sound, ofType: nil)
    if audioFilePath != nil {
      let audioFileURL = URL.init(fileURLWithPath: audioFilePath!)
      do {
        try audioPlayer = AVAudioPlayer(contentsOf: audioFileURL)
        if let player = audioPlayer {
          player.play()
        }
      } catch {
        print("error initializing AVAudioPlayer")
      }
    } else {
      print("audio file not found")
    }
  }
  
}
