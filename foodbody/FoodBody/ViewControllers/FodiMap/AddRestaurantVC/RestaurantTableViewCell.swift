//
//  RestaurantTableViewCell.swift
//  FoodBody
//
//  Created by Phuoc on 7/5/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

struct Restaurant {
    var title: String = ""
    var category: String = ""
    var openHours: String = ""
    var closeHours: String = ""
    var type: String = "Restaurant" // by default
}

protocol RestaurantTableViewCellDelegate: class {
    func restaurantTableViewCellEndEditing(restaurantModel: Restaurant)
}

class RestaurantTableViewCell: UITableViewCell {
    
    //MARK: Outlet
    @IBOutlet weak var titleTextField: InforTextField!
    @IBOutlet weak var categoryTextField: InforTextField!
    @IBOutlet weak var openHoursTextField: InforTextField!
    @IBOutlet weak var closeHoursTextField: InforTextField!
    @IBOutlet weak var restaurantButton: UIButton!
    @IBOutlet weak var foodTruckButton: UIButton!
    
    
    
    //MARK: Properties
    weak var delegate: RestaurantTableViewCellDelegate?
    var model: Restaurant = Restaurant()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionRestaurant() {
        model.type = "Restaurant"
        
        restaurantButton.setTitleColor(Style.Color.mainGreen, for: .normal)
        foodTruckButton.setTitleColor(Style.Color.mainGray, for: .normal)
        
        if let delegate = self.delegate {
            delegate.restaurantTableViewCellEndEditing(restaurantModel: model)
        }
    }
    
    @IBAction func actionFoodTruck() {
        model.type = "FoodTruck"
        
        foodTruckButton.setTitleColor(Style.Color.mainGreen, for: .normal)
        restaurantButton.setTitleColor(Style.Color.mainGray, for: .normal)
        
        if let delegate = self.delegate {
            delegate.restaurantTableViewCellEndEditing(restaurantModel: model)
        }
    }
    
}

extension RestaurantTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        model.title = titleTextField.text!
        model.category = categoryTextField.text!
        model.openHours = openHoursTextField.text!
        model.closeHours = closeHoursTextField.text!
        
        print(model)
        
        
        if let delegate = self.delegate {
            delegate.restaurantTableViewCellEndEditing(restaurantModel: model)
        }
        
    }
}
