//
//  ChartVC.swift
//  It Happened
//
//  Created by Drew Lanning on 11/11/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit
import JBChartView

class ChartVC: UIViewController, JBBarChartViewDelegate, JBBarChartViewDataSource {
  
  // MARK: Properties
  var activity: Activity?
  @IBOutlet weak var emptyDataLbl: UILabel!
  @IBOutlet weak var chartView: JBBarChartView!
  
  // MARK: Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    styleViews()
    chartView.dataSource = self
    chartView.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateViews()
  }
  
  func styleViews() {
    self.view.backgroundColor = Settings().colorTheme[.background]
    self.title = activity?.name!
    emptyDataLbl.textColor = Settings().colorTheme[.accent2]
    chartView.backgroundColor = .black
  }
  
  fileprivate func updateViews() {
    let hasActivity = self.activity!.instance!.count > 0
    emptyDataLbl.isHidden = hasActivity
    chartView.isHidden = !hasActivity
    if !chartView.isHidden {
      chartView.minimumValue = 0.0
      chartView.maximumValue = 100.0
      chartView.reloadData()
    }
  }
  
  // MARK: Chart Methods
  
  func numberOfBars(in barChartView: JBBarChartView!) -> UInt {
    return 10
  }
  
  func barChartView(_ barChartView: JBBarChartView!, heightForBarViewAt index: UInt) -> CGFloat {
    return 50
  }
  
  func barChartView(_ barChartView: JBBarChartView!, colorForBarViewAt index: UInt) -> UIColor! {
    return .red
  }
  
}
