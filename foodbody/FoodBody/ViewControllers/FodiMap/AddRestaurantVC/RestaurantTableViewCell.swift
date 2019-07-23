//
//  RestaurantTableViewCell.swift
//  FoodBody
//
//  Created by Phuoc on 7/5/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit
import GooglePlaces

struct Restaurant {
    var title: String = ""
    var category: String = ""
    var openHours: String = ""
    var closeHours: String = ""
    var type: String = "RESTAURANT" // by default
}

protocol RestaurantTableViewCellDelegate: class {
    func restaurantTableViewCellEndEditing(restaurantModel: Restaurant)
    func restaurantTableViewCellDidBeginSearchAddress()
}

class RestaurantTableViewCell: UITableViewCell {
    
    //MARK: Outlet
    @IBOutlet weak var titleTextField: InforTextField!
    @IBOutlet weak var categoryTextField: InforTextField!
    @IBOutlet weak var openHoursTextField: InforTextField!
    @IBOutlet weak var closeHoursTextField: InforTextField!
    @IBOutlet weak var addressTextField: InforTextField!
    
    @IBOutlet weak var restaurantButton: UIButton!
    @IBOutlet weak var foodTruckButton: UIButton!
    
    
    var  categoryList: [CategoryModel] = []
	
    
    
    
    //MARK: Properties
    weak var delegate: RestaurantTableViewCellDelegate?
    var model: Restaurant = Restaurant()
    
    enum RestaurantType: String {
        case restaurant = "RESTAURANT"
        case foodTruck = "FOOD_TRUCK"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupDatePiker()
        self.setupCategoryPicker()
		
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupDatePiker() {
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
    
    private func setupCategoryPicker() {
        let catePicker = UIPickerView()
        categoryTextField.inputView = catePicker
        catePicker.delegate = self
        catePicker.dataSource = self
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
    
    @IBAction func textFieldTapped(_ sender: Any) {
       addressTextField.resignFirstResponder()
        if let delegate = self.delegate {
            delegate.restaurantTableViewCellDidBeginSearchAddress()
        }
    }
    
    @objc func setTimeOpen(_sender : UIDatePicker){
       
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: _sender.date)
        
        if let hour = comp.hour, let minute = comp.minute {
            if minute < 10 {
                openHoursTextField.text = "\(hour):0\(minute)"
            } else {
                openHoursTextField.text = "\(hour):\(minute)"
            }
        }
        
    }
    
    @objc func setTimeClose(_sender : UIDatePicker){
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: _sender.date)
        
        if let hour = comp.hour, let minute = comp.minute {
            if minute < 10 {
                closeHoursTextField.text = "\(hour):0\(minute)"
            } else {
                closeHoursTextField.text = "\(hour):\(minute)"
            }
            
        }
    }
    
    func bindData(restaurant: RestaurantRequest) {
        titleTextField.text = restaurant.name
        categoryTextField.text = restaurant.category
        openHoursTextField.text = restaurant.open_hour
        closeHoursTextField.text = restaurant.close_hour
        addressTextField.text = restaurant.address
    }
    
}

extension RestaurantTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        model.title = titleTextField.text!
        model.openHours = openHoursTextField.text!
        model.closeHours = closeHoursTextField.text!
		
		// set default value for text field category
		if textField == categoryTextField && textField.text!.isEmpty {
			categoryTextField.text = categoryList.first?.name
		}
        
        if let delegate = self.delegate {
            delegate.restaurantTableViewCellEndEditing(restaurantModel: model)
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {// disable editing 
        switch textField {
        case categoryTextField:
            return false
        case openHoursTextField:
            return false
        case closeHoursTextField:
            return false
        default:
            return true
        }
    }
}

extension RestaurantTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: UIPickerView Delegation
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryList[row].name
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if !categoryList.isEmpty {
			categoryTextField.text = categoryList[row].name
			model.category = categoryList[row].key
		}
		
    }
}
