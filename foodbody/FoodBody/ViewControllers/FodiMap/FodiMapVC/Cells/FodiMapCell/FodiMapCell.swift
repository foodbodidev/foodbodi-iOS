//
//  FodiMapCell.swift
//  FoodBody
//
//  Created by Toan Tran on 7/9/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class FodiMapCell: UICollectionViewCell {
    @IBOutlet weak var imvRestaurant:UIImageView!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblCategory:UILabel!
    @IBOutlet weak var lblKcal:UILabel!
    @IBOutlet weak var lblTime:UILabel!
    
    
    func bindData(dic: [String: Any]) {
        self.lblName.text = dic["name"] as? String
        self.lblCategory.text = dic["category"] as? String
        self.lblKcal.text = "300kcal"
        if let openTime = dic["open_hour"] as? String,
            let closeTime = dic["open_hour"] as? String{
            self.lblTime.text =   openTime + "~" + closeTime
        }
        
        if let imageUrl = URL(string: dic["photo"] as? String ?? "") {
            self.imvRestaurant.kf.setImage(with: imageUrl, placeholder: nil)
        }
    }
}
