//
//  DeleteConfirmationVC.swift
//  It Happened
//
//  Created by Drew Lanning on 9/16/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit
import AVFoundation

public class DeleteConfirmationVC: UIViewController, AudioPlayer {

  public var audioPlayer: AVAudioPlayer?
  
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var messageLbl: UILabel!
  
  @IBOutlet weak var okButton: BaseButton!
  
  var completion: (() -> ())? = nil
  let generator = UINotificationFeedbackGenerator()
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    playSound(called: Sound.deletePopover)
    titleLbl.textColor = Settings().colorTheme[.primary]
    titleLbl.font = UIFont.systemFont(ofSize: 22, weight: .bold)
    okButton.backgroundColor = Settings().colorTheme[.accent3]
    messageLbl.text = PopupMessages.deleteMessage
    titleLbl.text = PopupMessages.deleteTitle
    generator.notificationOccurred(.warning)
  }
  
  @IBAction func okPressed(sender: UIButton) {
    if let closure = completion {
      playSound(called: Sound.buttonPress)
      closure()
      self.dismiss(animated: true, completion: nil)
      self.generator.notificationOccurred(.success)
    }
  }
  
  @IBAction func cancelPressed(sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }

}
