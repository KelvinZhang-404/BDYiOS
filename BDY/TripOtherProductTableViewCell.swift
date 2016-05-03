//
//  TripOhterProductTableViewCell.swift
//  BDY
//
//  Created by 张联学 on 12/01/2016.
//  Copyright © 2016 gdt. All rights reserved.
//

import UIKit

class TripOtherProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productNormalPrice: UILabel!
    @IBOutlet weak var productSepcialPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
