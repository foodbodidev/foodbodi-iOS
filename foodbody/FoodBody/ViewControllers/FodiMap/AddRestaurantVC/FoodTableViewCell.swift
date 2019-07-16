//
//  FoodTableViewCell.swift
//  FoodBody
//
//  Created by Phuoc on 7/4/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit



class FoodTableViewCell: UITableViewCell {
    
    //MARK: Outlet
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var calorLabel: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(data: FoodRequest) {
        nameLabel.text = data.name
        priceLabel.text = "\(data.price)" + "$"
        calorLabel.text = "\(data.calor)" + " Kcal"
        foodImageView.image = data.image
        
    }
    
}
