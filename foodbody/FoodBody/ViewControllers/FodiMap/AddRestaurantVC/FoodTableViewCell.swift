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
        foodImageView.layer.cornerRadius = 5;
        foodImageView.layer.masksToBounds = true;
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(data: FoodModel) {
        nameLabel.text = data.name
        priceLabel.text = "\(data.price)" + "$"
        calorLabel.text = "\(data.calo)" + " Kcal"
        foodImageView.image = data.image

        
        foodImageView.setImageWithUrl(url: data.photo)
        
    }
    
    
}
