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
  var audioPlayer: AVAudioPlayer { get set }
  func playSound(file: String)
}

public extension AudioPlayer {
  
  func playSound(called sound: String, ofType type: String) {
    // load and play the sound?
    let audioFilePath = Bundle.main.path(forResource: sound, ofType: type)
    if audioFilePath != nil {
      let audioFileURL = URL.init(fileURLWithPath: audioFilePath!)
      do {
        try audioPlayer = AVAudioPlayer(contentsOf: audioFileURL)
        audioPlayer.play()
      } catch {
        print("error initializing AVAudioPlayer")
      }
    } else {
      print("audio file not found")
    }
  }
  
}
