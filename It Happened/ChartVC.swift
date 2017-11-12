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
  var formatter: DateFormatter!
  @IBOutlet weak var emptyDataLbl: UILabel!
  @IBOutlet weak var chartView: JBBarChartView!
  @IBOutlet weak var leftLbl: UILabel!
  @IBOutlet weak var rightLbl: UILabel!
  @IBOutlet weak var infoView: InfoView!
  
  // MARK: Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    styleViews()
    
    chartView.dataSource = self
    chartView.delegate = self
    
    formatter = DateFormatter()
    formatter.dateFormat = "MMM d"
      
    allDatesForActivity = activity.getAllDates()
    let cal = Calendar(identifier: .gregorian)
    let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
    for d in 1 ..< 8 {
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
    leftLbl.text = formatter.string(from: dateRange.first!)
    leftLbl.textColor = .white
    rightLbl.text = "Today"
    rightLbl.textColor = .white
    
    infoView.hideSubviews()
  }
  
  // MARK: Chart Methods
  
  func numberOfBars(in barChartView: JBBarChartView!) -> UInt {
    return UInt(dateRange.count)
  }
  
  func barChartView(_ barChartView: JBBarChartView!, heightForBarViewAt index: UInt) -> CGFloat {
    if allDatesForActivity.contains(dateRange[Int(index)]) {
      let date = dateRange[Int(index)]
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
    infoView.configureSubviews(withActivity: self.activity, forDate: date)
  }
  
  func didDeselect(_ barChartView: JBBarChartView!) {
    infoView.hideSubviews()
  }
  
}
