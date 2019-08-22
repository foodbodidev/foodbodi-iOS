//
//  SearchTypeRestaurantCell.swift
//  FoodBody
//
//  Created by Toan Tran on 8/21/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class SearchTypeRestaurantCell: UITableViewCell {
    
    @IBOutlet var lblName:UILabel!
    @IBOutlet var lblType:UILabel!
    @IBOutlet var lblAddress:UILabel!
    @IBOutlet var imgType:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
