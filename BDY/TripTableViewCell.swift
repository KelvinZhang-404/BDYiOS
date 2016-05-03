//
//  TripTableViewCell.swift
//  BDY
//
//  Created by 张联学 on 18/12/2015.
//  Copyright © 2015 gdt. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell {

    // Mark: Properties
    
    @IBOutlet weak var tripImageView: UIImageView!
    @IBOutlet weak var tripLabelName: UILabel!
    @IBOutlet weak var tripCoverHint: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
