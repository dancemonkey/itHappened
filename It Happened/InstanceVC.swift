//
//  InstanceVC.swift
//  It Happened
//
//  Created by Drew Lanning on 8/31/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit

class InstanceVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var newButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  
  var activity: Activity?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.setNavigationBarHidden(false, animated: true)
    styleViews()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    if let activityToView = activity {
      // load all instances from activity into table view
    }
  }
  
  func styleViews() {
    newButton.setTitleColor(Colors.accent2, for: .normal)
    tableView.backgroundColor = Colors.black
    // Set VC title from name of instance selected
  }
  
  // MARK: Tableview functions
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "instanceCell")
    return cell!
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let editVC = storyboard?.instantiateViewController(withIdentifier: "EditInstanceVC")
    navigationController?.show(editVC!, sender: self)
  }
  
  // MARK: Segue to Editing Instance
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "editInstance" {
      // DI instance from selected row into edit VC
    }
  }
  
}
