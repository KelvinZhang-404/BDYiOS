//
//  TripMetaInfoTableViewCell.swift
//  BDY
//
//  Created by 张联学 on 12/01/2016.
//  Copyright © 2016 gdt. All rights reserved.
//

import UIKit

class TripMetaInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var metaInfoType: UILabel!
    @IBOutlet weak var metaInfoDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
