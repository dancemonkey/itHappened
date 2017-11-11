//
//  ChartVC.swift
//  It Happened
//
//  Created by Drew Lanning on 11/11/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit

class ChartVC: UIViewController {
  
  // MARK: Properties
  var activity: Activity?
  @IBOutlet weak var emptyDataLbl: UILabel!
  
  // MARK: Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    styleViews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateViews()
  }
  
  func styleViews() {
    self.view.backgroundColor = Settings().colorTheme[.background]
    self.title = activity?.name!
    emptyDataLbl.textColor = Settings().colorTheme[.accent2]
  }
  
  fileprivate func updateViews() {
    let hasActivity = self.activity!.instance!.count > 0
    emptyDataLbl.isHidden = hasActivity
    // also SHOW chart view if there is no activity
  }
  
}
