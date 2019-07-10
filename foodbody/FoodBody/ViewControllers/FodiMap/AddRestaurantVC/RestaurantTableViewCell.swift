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
    var type: String = "RESTAURANT" // by default
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
    
    enum RestaurantType: String {
        case restaurant = "RESTAURANT"
        case foodTruck = "FOOD_TRUCK"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        //Date Picker
        let datePickerOpen = UIDatePicker()
        datePickerOpen.datePickerMode = .time
        datePickerOpen.addTarget(self, action: #selector(self.setTimeOpen(_sender:)), for: .valueChanged)
        datePickerOpen.timeZone = TimeZone.current
        openHoursTextField.inputView = datePickerOpen
        
        let datePickerClose = UIDatePicker()
        datePickerClose.datePickerMode = .time
        datePickerClose.addTarget(self, action: #selector(self.setTimeClose(_sender:)), for: .valueChanged)
        datePickerClose.timeZone = TimeZone.current
        closeHoursTextField.inputView = datePickerClose
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionRestaurant() {
        model.type = RestaurantType.restaurant.rawValue
        
        restaurantButton.setTitleColor(Style.Color.mainGreen, for: .normal)
        foodTruckButton.setTitleColor(Style.Color.mainGray, for: .normal)
        
        if let delegate = self.delegate {
            delegate.restaurantTableViewCellEndEditing(restaurantModel: model)
        }
    }
    
    @IBAction func actionFoodTruck() {
        model.type = RestaurantType.foodTruck.rawValue
        
        foodTruckButton.setTitleColor(Style.Color.mainGreen, for: .normal)
        restaurantButton.setTitleColor(Style.Color.mainGray, for: .normal)
        
        if let delegate = self.delegate {
            delegate.restaurantTableViewCellEndEditing(restaurantModel: model)
        }
    }
    
    @objc func setTimeOpen(_sender : UIDatePicker){
       
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: _sender.date)
        
        if let hour = comp.hour, let minute = comp.minute {
            openHoursTextField.text = "\(hour):\(minute)"
        }
        
    }
    
    @objc func setTimeClose(_sender : UIDatePicker){
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: _sender.date)
        
        if let hour = comp.hour, let minute = comp.minute {
            closeHoursTextField.text = "\(hour):\(minute)"
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
