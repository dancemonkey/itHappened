//
//  ChartVC.swift
//  It Happened
//
//  Created by Drew Lanning on 11/11/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit
import JBChartView

class ChartVC: UIViewController {
  
  // MARK: Properties
  var activity: Activity?
  @IBOutlet weak var emptyDataLbl: UILabel!
  @IBOutlet weak var chartView: JBChartView!
  
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
    chartView.backgroundColor = .red
  }
  
  fileprivate func updateViews() {
    let hasActivity = self.activity!.instance!.count > 0
    emptyDataLbl.isHidden = hasActivity
    chartView.isHidden = !hasActivity
  }
  
  // MARK: Chart Methods
  
}
