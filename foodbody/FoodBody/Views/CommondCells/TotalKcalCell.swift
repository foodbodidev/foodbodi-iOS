//
//  TotalKcalCell.swift
//  FoodBody
//
//  Created by Toan Tran on 8/2/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class TotalKcalCell: UITableViewCell {
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var viView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viView.layer.masksToBounds = true;
        viView.layer.cornerRadius = 8;
    }
}
