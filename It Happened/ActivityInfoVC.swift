//
//  ActivityInfoVC.swift
//  It Happened
//
//  Created by Drew Lanning on 10/17/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit
import AVFoundation

class ActivityInfoVC: UIViewController {
  
  public var audioPlayer: AVAudioPlayer?
  
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var dateCreatedLbl: UILabel!
  @IBOutlet weak var totalLbl: UILabel!
  @IBOutlet weak var averageLbl: UILabel!
  
  @IBOutlet weak var okButton: BaseButton!
  
  let generator = UINotificationFeedbackGenerator()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
  
}
