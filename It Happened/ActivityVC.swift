//
//  ViewController.swift
//  It Happened
//
//  Created by Drew Lanning on 8/31/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit

class ActivityVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var headingLbl: UILabel!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var newButton: UIButton!
  @IBOutlet weak var helpButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    styleViews()
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  func styleViews() {
    headingLbl.textColor = Colors.primary
    self.view.backgroundColor = Colors.black
    tableView.backgroundColor = Colors.black
    newButton.setTitleColor(Colors.accent2, for: .normal)
    helpButton.setTitleColor(Colors.accent1, for: .normal)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func newTapped(sender: UIButton) {
    
  }
  
  // MARK: Tableview Functions
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell")
    return cell!
  }
  
}

