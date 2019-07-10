//
//  AddRestaurantVC.swift
//  FoodBody
//
//  Created by Toan Tran on 7/4/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit


enum AddResEnum: Int, CaseIterable {
    case restaurant = 0
    case addMenu
    case foodDisplay
}

class AddRestaurantVC: BaseVC {
    
    //MARK: ==== OUTLET ====
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Properties
	var restaurant: RestaurantRequest = RestaurantRequest()

	// MARK: Life cycle of viewcontroller
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        registerNib()
	
    }
	
    //MARK: === ACTION  ===
    
    @IBAction func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
	
	@IBAction func actionSubmit() {
        if validateData() {
            self.showLoading()
            RequestManager.createRestaurant(request: restaurant) { [weak self] (result, error) in

                guard let strongSelf = self else { return }
                strongSelf.hideLoading()

                if let result = result {
                    if result.isSuccess {
                        strongSelf.alertMessage(message: "Create restaurant successfully", completion: {
                            strongSelf.actionBack()
                        })
                    }
                }
                if let error = error {
                    strongSelf.alertMessage(message: error.localizedDescription)
                }

            }

        }
		
	}
	
	//MARK: OTHER METHOD
	
	private func validateData() -> Bool {
		if restaurant.name.isEmpty {
			self.alertMessage(message: "Restaurant's name can not be empty")
			return false
		}
		
		if restaurant.category.isEmpty {
			self.alertMessage(message: "Restaurant's category can not be empty")
			return false
		}
		
		if restaurant.open_hour.isEmpty {
			self.alertMessage(message: "Restaurant's open hour can not be empty")
			return false
		}
		
		if restaurant.close_hour.isEmpty {
			self.alertMessage(message: "Restaurant's close hour can not be empty")
			return false
		}
		
		if restaurant.foodRequest.count == 0 {
			self.alertMessage(message: "Please add at least one kind of food")
			return false
		}
		
		return true
	}
	
	private func registerNib() {
		tableView.register(UINib.init(nibName: MenuTableViewCell.className, bundle: nil), forCellReuseIdentifier: MenuTableViewCell.className)
		tableView.register(UINib.init(nibName: FoodTableViewCell.className, bundle: nil), forCellReuseIdentifier: FoodTableViewCell.className)
		tableView.register(UINib.init(nibName: RestaurantTableViewCell.className, bundle: nil), forCellReuseIdentifier: RestaurantTableViewCell.className)
		
	}

}


extension AddRestaurantVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return AddResEnum.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == AddResEnum.foodDisplay.rawValue {
            return restaurant.foodRequest.count
        }
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case AddResEnum.restaurant.rawValue:
            let resCell = tableView.dequeueReusableCell(withIdentifier: RestaurantTableViewCell.className, for: indexPath) as! RestaurantTableViewCell
            resCell.delegate = self
            return resCell
            
        case AddResEnum.addMenu.rawValue :
            let addMenuCell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.className, for: indexPath) as! MenuTableViewCell
            addMenuCell.delegate = self
            return addMenuCell
            
        case AddResEnum.foodDisplay.rawValue:
            let foodCell = tableView.dequeueReusableCell(withIdentifier: FoodTableViewCell.className, for: indexPath) as! FoodTableViewCell
            foodCell.bindData(data: restaurant.foodRequest[indexPath.row])
            return foodCell
        default:
            return UITableViewCell()
        }
    }
}

extension AddRestaurantVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
            
        case AddResEnum.restaurant.rawValue:
           return 0.339*self.view.frame.height
            
        case AddResEnum.addMenu.rawValue :
            return 200
            
        case AddResEnum.foodDisplay.rawValue:
           return 0.13*self.view.frame.height
            
        default:
            return 0
        }
    }
}

extension AddRestaurantVC: RestaurantTableViewCellDelegate, MenuTableViewCellDelegate {
    
    func didClickOnAddButton(food: Food) {
		
		let foodRequest = FoodRequest(name: food.name, price: food.price, calor: food.calor)
		
        restaurant.foodRequest.append(foodRequest)
        tableView.reloadData()
    }
    
    
    
    func restaurantTableViewCellEndEditing(restaurantModel: Restaurant) {
        restaurant.name = restaurantModel.title
		restaurant.category = restaurantModel.category
		restaurant.close_hour = restaurantModel.closeHours
		restaurant.open_hour = restaurantModel.openHours
		restaurant.type = restaurantModel.type
    }

}
