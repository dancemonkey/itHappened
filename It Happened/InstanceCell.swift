//
//  InstanceCell.swift
//  It Happened
//
//  Created by Drew Lanning on 9/2/17.
//  Copyright © 2017 Drew Lanning. All rights reserved.
//

import UIKit

class InstanceCell: UITableViewCell {
  
  @IBOutlet weak var timeLbl: UILabel!
  @IBOutlet weak var noteLbl: UILabel!
  
  func styleViews() {
    timeLbl.textColor = Colors.accent2
    noteLbl.textColor = Colors.accent1
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    styleViews()
  }
  
  func configureCell(with instance: Instance) {
    timeLbl.text = instance.getFormattedTime()
    noteLbl.text = instance.note != nil ? instance.note! : ""
    self.selectionStyle = .none
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
}
