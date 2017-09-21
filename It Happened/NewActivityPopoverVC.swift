//
//  NewActivityPopoverVC.swift
//  It Happened
//
//  Created by Drew Lanning on 9/15/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit
import AVFoundation

public class NewActivityPopoverVC: UIViewController, AudioPlayer {
  
  public var audioPlayer: AVAudioPlayer?
  
  @IBOutlet weak var nameFld: UITextField!
  @IBOutlet weak var titleLbl: UILabel!
  
  var completion: ((String) -> ())? = nil
  var activity: Activity? = nil
  
  let generator = UINotificationFeedbackGenerator()
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    titleLbl.textColor = Colors.primary
    titleLbl.font = UIFont.systemFont(ofSize: 22, weight: .bold)
    if activity == nil {
      nameFld.becomeFirstResponder()
      titleLbl.text = PopupMessages.newActivityTitle
    } else {
      titleLbl.text = PopupMessages.updateActivityTitle
      nameFld.text = activity!.name
    }
  }
  
  @IBAction func okPressed(sender: UIButton) {
    if let closure = completion, let name = nameFld.text, name != "" {
      playSound(called: Sound.buttonPress)
      closure(name)
      self.dismiss(animated: true, completion: nil)
      self.generator.notificationOccurred(.success)
    }
  }
  
  @IBAction func cancelPressed(sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
}
