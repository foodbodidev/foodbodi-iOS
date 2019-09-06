//
//  CaloInfoCell.swift
//  FoodBody
//
//  Created by Toan Tran on 9/6/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class CaloInfoCell: UITableViewCell {
    @IBOutlet var lblCategory:UILabel!
    @IBOutlet var lblENERC_KCAL:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
