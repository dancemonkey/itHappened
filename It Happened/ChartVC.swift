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
  var activity: Activity!
  var allDatesForActivity: [Date]!
  var dateRange: [Date] = [Date]()
//  var dateRange: (from: Date, to: Date)!
  @IBOutlet weak var emptyDataLbl: UILabel!
  @IBOutlet weak var chartView: JBBarChartView!
  
  // MARK: Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    styleViews()
    
    chartView.dataSource = self
    chartView.delegate = self
    
    allDatesForActivity = activity.getAllDates()
    let cal = Calendar(identifier: .gregorian)
    let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
    for d in 1 ... 7 {
      let newDate = Calendar.current.date(byAdding: .day, value: d, to: startDate)
      dateRange.append(cal.startOfDay(for: newDate!))
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateViews()
  }
  
  func styleViews() {
    self.view.backgroundColor = Settings().colorTheme[.background]
    self.title = activity?.name!
    emptyDataLbl.textColor = Settings().colorTheme[.accent2]
    chartView.backgroundColor = Settings().colorTheme[.background]
  }
  
  fileprivate func updateViews() {
    let hasActivity = self.activity!.instance!.count > 0
    emptyDataLbl.isHidden = hasActivity
    chartView.isHidden = !hasActivity
    if !chartView.isHidden {
      chartView.minimumValue = 0
      chartView.reloadData()
    }
  }
  
  // MARK: Chart Methods
  
  func numberOfBars(in barChartView: JBBarChartView!) -> UInt {
//    return UInt(activity.getAllDates()!.count)
    // just show one week
    return UInt(dateRange.count)
  }
  
  func barChartView(_ barChartView: JBBarChartView!, heightForBarViewAt index: UInt) -> CGFloat {
//    let date = activity.getAllDates()![Int(index)]
    if allDatesForActivity.contains(dateRange[Int(index)]) {
      let date = allDatesForActivity[Int(index)]
      return CGFloat(activity.getInstanceCount(forDate: date))
    } else {
      return 0
    }
  }
  
  func barChartView(_ barChartView: JBBarChartView!, colorForBarViewAt index: UInt) -> UIColor! {
    return Settings().colorTheme[.primary]
  }
  
  func barChartView(_ barChartView: JBBarChartView!, didSelectBarAt index: UInt) {
    let date = dateRange[Int(index)]
    print(date)
    print(activity.getInstanceCount(forDate: date))
  }
  
  func didDeselect(_ barChartView: JBBarChartView!) {
    print("-=-=-=-=")
  }
  
}
