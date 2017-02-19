//
//  NumberTableViewCell.swift
//  Wellbeing
//
//  Created by Jeffrey Xiong on 10/24/15.
//  Copyright © 2015 Rice Apps. All rights reserved.
//

import Foundation
import UIKit

class NumbersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
