//
//  ReservationCell.swift
//  FoodBody
//
//  Created by Toan Tran on 8/2/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class ReservationCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblCalo: UILabel!
    @IBOutlet weak var viBoder: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblCalo.layer.cornerRadius = 5;
        self.lblCalo.layer.masksToBounds = true;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
