//
//  ResortTableViewCell.swift
//  BDY
//
//  Created by 张联学 on 8/01/2016.
//  Copyright © 2016 gdt. All rights reserved.
//

import UIKit

class ResortTableViewCell: UITableViewCell {

    // Mark: Properties
    @IBOutlet weak var resortImageView: UIImageView!
    @IBOutlet weak var resortEnName: UITextField!
    @IBOutlet weak var resortCnName: UITextField!
    @IBOutlet weak var resortDistance: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
