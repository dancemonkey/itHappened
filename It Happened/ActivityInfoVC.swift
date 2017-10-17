//
//  ActivityInfoVC.swift
//  It Happened
//
//  Created by Drew Lanning on 10/17/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit
import AVFoundation

public class ActivityInfoVC: UIViewController, AudioPlayer {
  
  public var audioPlayer: AVAudioPlayer?
  
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var dateCreatedLbl: UILabel!
  @IBOutlet weak var totalLbl: UILabel!
  @IBOutlet weak var averageLbl: UILabel!
  
  @IBOutlet weak var okButton: BaseButton!
  
  let generator = UINotificationFeedbackGenerator()
  var activity: Activity?
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    titleLbl.textColor = Settings().colorTheme[.primary]
    let labelFont = UIFont.systemFont(ofSize: 12, weight: .thin)
    titleLbl.font = UIFont.systemFont(ofSize: 22, weight: .bold)
    dateCreatedLbl.font = labelFont
    totalLbl.font = labelFont
    averageLbl.font = labelFont
    okButton.backgroundColor = Settings().colorTheme[.accent1]
    if let activity = activity {
      titleLbl.text = activity.name
      let formatter = DateFormatter()
      formatter.dateFormat = "EEEE, MMM d, yyyy"
      dateCreatedLbl.text = "Created: \(formatter.string(from: activity.created! as Date))"
      totalLbl.text = "Total: \(String(describing: activity.instance!.count))"
      averageLbl.text = "Average / day: \(activity.getAveragePerDay())"
    }
  }
  
  @IBAction func okButtonPressed() {
    self.dismiss(animated: true, completion: nil)
    playSound(called: Sound.buttonPress)
  }
  
}
