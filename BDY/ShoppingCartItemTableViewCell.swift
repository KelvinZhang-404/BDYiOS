//
//  ShoppingCartItemTableViewCell.swift
//  BDY
//
//  Created by 张联学 on 20/01/2016.
//  Copyright © 2016 gdt. All rights reserved.
//

import UIKit

class ShoppingCartItemTableViewCell: UITableViewCell {

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var unitPrice: UILabel!
    @IBOutlet weak var departTime: UILabel!
    @IBOutlet weak var unitNumber: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
