//
//  ViewController.swift
//  It Happened
//
//  Created by Drew Lanning on 8/31/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit

class ActivityVC: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.setNavigationBarHidden(true, animated: true)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func newTapped(sender: UIButton) {
    let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "InstanceVC")
    self.navigationController?.pushViewController(nextVC!, animated: true)
  }

}

