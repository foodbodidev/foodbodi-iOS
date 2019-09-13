//
//  RestaurantTableViewCell.swift
//  FoodBody
//
//  Created by Phuoc on 7/5/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit
import GooglePlaces

protocol RestaurantTableViewCellDelegate: class {
    func restaurantTableViewCellEndEditing(restaurantModel: RestaurantRequest)
}

class RestaurantTableViewCell: UITableViewCell {
    
    //MARK: Outlet
    @IBOutlet weak var categoryTextField: InforTextField!
    @IBOutlet weak var openHoursTextField: InforTextField!
    @IBOutlet weak var closeHoursTextField: InforTextField!
    
    @IBOutlet weak var restaurantButton: UIButton!
    @IBOutlet weak var foodTruckButton: UIButton!
    @IBOutlet weak var viButton:UIView!
    @IBOutlet weak var viContent:UIView!
    
    var categoryList: [CategoryModel] = AppManager.categoryList
	
	var closeTime: Time?// use to compare closetime > opentime
	var openTime: Time?
	

    //MARK: Properties
    weak var delegate: RestaurantTableViewCellDelegate?
    var model: RestaurantRequest = RestaurantRequest() {
        didSet {
            categoryTextField.text = categoryList.filter({$0.key == model.category}).first?.name
            openHoursTextField.text = model.open_hour
            closeHoursTextField.text = model.close_hour
            model.isValidTime = validateTime()
        }
    }
    
    enum RestaurantType: String {
        case restaurant = "RESTAURANT"
        case foodTruck = "FOOD_TRUCK"
    }
	
	struct Time: Comparable {

		var hours: Int = 0
		var minutes: Int = 0
		
		init() {
			
		}
		
		init(hours: Int, minutes: Int) {
			self.hours = hours
			self.minutes = minutes
		}
		
		static func < (lhs: RestaurantTableViewCell.Time, rhs: RestaurantTableViewCell.Time) -> Bool {
			if lhs.hours < rhs.hours {
				return true
			}
			
			if lhs.hours == rhs.hours {
				if lhs.minutes < rhs.minutes {
					return true
				}
			}
			return false
		}
	}

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupDatePiker()
        self.setupCategoryPicker()
        self.viContent.layer.cornerRadius = 10;
        self.viContent.layer.masksToBounds = true;
        self.viButton.layer.cornerRadius = 10;
        self.viButton.layer.masksToBounds = true;
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
    
    @objc func setTimeOpen(_sender : UIDatePicker){
       
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: _sender.date)
		
		guard let hour = comp.hour, let minute = comp.minute else {
			return
		}
		
		openTime = Time(hours: hour, minutes: minute)
		model.isValidTime = validateTime()
        
		if minute < 10 {
			openHoursTextField.text = "\(hour):0\(minute)"
		} else {
			openHoursTextField.text = "\(hour):\(minute)"
		}
        
    }
    
    @objc func setTimeClose(_sender : UIDatePicker){
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: _sender.date)
		
		guard let hour = comp.hour, let minute = comp.minute else {
			return
		}
		
		closeTime = Time(hours: hour, minutes: minute)
		model.isValidTime = validateTime()
	
		if minute < 10 {
			closeHoursTextField.text = "\(hour):0\(minute)"
		} else {
			closeHoursTextField.text = "\(hour):\(minute)"
		}
    }
	
	func validateTime() -> Bool {
		if let openTime = openTime, let closeTime = closeTime {
			if openTime >= closeTime {
				return false
			}
		}
		return true
	}
    
    func bindData(restaurant: RestaurantRequest) {
      
        
        model = restaurant
        
        if restaurant.type == RestaurantType.restaurant.rawValue {
            restaurantButton.setTitleColor(Style.Color.mainGreen, for: .normal)
            foodTruckButton.setTitleColor(Style.Color.mainGray, for: .normal)
        } else {
            foodTruckButton.setTitleColor(Style.Color.mainGreen, for: .normal)
            restaurantButton.setTitleColor(Style.Color.mainGray, for: .normal)
        }
    }
}

extension RestaurantTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
		
		// set default value for text field category
		if textField == categoryTextField && textField.text!.isEmpty {
			categoryTextField.text = categoryList.first?.name
			model.category = categoryList[0].key// default value first
		}
        
        saveDataToModel()
		
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
    
    func saveDataToModel() {
        model.category = categoryList.filter({$0.name == categoryTextField.text!}).first?.key ?? ""
        model.open_hour = openHoursTextField.text!
        model.close_hour = closeHoursTextField.text!
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
