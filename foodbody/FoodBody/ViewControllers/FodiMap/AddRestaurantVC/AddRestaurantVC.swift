//
//  AddRestaurantVC.swift
//  FoodBody
//
//  Created by Toan Tran on 7/4/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit
import GooglePlaces
protocol AddRestaurantVCDelegate {
    func addRestaurantSuccessful(sender:AddRestaurantVC)
}
class AddRestaurantVC: BaseVC {
    
    //MARK: ==== OUTLET ====
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerImageView: UIImageView!
    var delegate : AddRestaurantVCDelegate?
    
    //MARK: Properties
	var restaurant: RestaurantRequest = RestaurantRequest()
    var foodModel: [FoodModel] = []
	var photoFoodURL: String = ""
    var categoryList: [CategoryModel] = []
    var imagePicker = UIImagePickerController()
    var imageFood: UIImage?
	
	enum AddResEnum: Int, CaseIterable {
		case restaurant = 0
		case addMenu
		case foodDisplay
	}
	
	enum PhotoType {
		case restaurant
		case food
	}
	
	var photoType: PhotoType = .restaurant
	
	//MARK: Enum

	// MARK: Life cycle of viewcontroller
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        registerNib()
        getCategory()
        bindDataFromMyRestaurant()
        getFoodByResId()
    }
	
    //MARK: === ACTION  ===
	
    @IBAction func actionBacks() {
        self.navigationController?.popViewController(animated: true)
    }
	
	@IBAction func actionSubmit() {
        print(restaurant.toJSON())

        if validateData() {
            self.showLoading()
            RequestManager.updateRestaurant(request: restaurant) { [weak self] (result, error) in

                guard let strongSelf = self else { return }
                strongSelf.hideLoading()

                if let result = result {
                    if result.isSuccess {
                        strongSelf.alertMessage(message: "Create restaurant successfully", completion: {
							if let delegate = strongSelf.delegate {
								delegate.addRestaurantSuccessful(sender: strongSelf)
							}
                            strongSelf.navigationController?.popToRootViewController(animated: true)
                        })

                    } else {
                        strongSelf.alertMessage(message: result.message)
                    }
                }
                if let error = error {
                    strongSelf.alertMessage(message: error.localizedDescription)
                }

            }

        }
		
	}
    
    @IBAction func actionOpenSelectionSheet() {
		photoType = .restaurant
        openActionSheet()
    }
	
	//MARK: OTHER METHOD
    
    private func bindDataFromMyRestaurant() {
        guard let myRestaurant = AppManager.restaurant else { return  }
        restaurant.mapDataFromMyRestaurant(myRestaurant: myRestaurant)
    }
    
    private func openActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (_) in
            self.openCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Open Gallery", style: .default, handler: { (_) in
            self.openGallery()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        present(actionSheet, animated: true)
    }
    
    private func openGallery() {
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            print("Library is not available")
            return
        }
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func openCamera() {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is not available")
            return
        }
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
	
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
		
		if foodModel.count == 0 {
			self.alertMessage(message: "Please add at least one kind of food")
			return false
		}
		
		if !restaurant.isValidTime {
			self.alertMessage(message: "Open hours should be less than close hours")
			return false
		}
		
		return true
	}
	
	private func registerNib() {
		tableView.register(UINib.init(nibName: MenuTableViewCell.className, bundle: nil), forCellReuseIdentifier: MenuTableViewCell.className)
		tableView.register(UINib.init(nibName: FoodTableViewCell.className, bundle: nil), forCellReuseIdentifier: FoodTableViewCell.className)
		tableView.register(UINib.init(nibName: RestaurantTableViewCell.className, bundle: nil), forCellReuseIdentifier: RestaurantTableViewCell.className)
	}
    
    private func getCategory() {
        self.showLoading()
        
        RequestManager.getCategoty { (data, error) in
            self.hideLoading()
            
            if let data  = data {
                self.categoryList = data
                self.tableView.reloadData()
            }
        }
    }
    
    private func getFoodByResId() {
        self.showLoading()
        
        RequestManager.getFoodWithRestaurantId(id: AppManager.user?.restaurantId ?? "") { (result, error) in
            self.foodModel = result?.data ?? []
            self.tableView.reloadData()
        }
    }
}


extension AddRestaurantVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return AddResEnum.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == AddResEnum.foodDisplay.rawValue {
            return self.foodModel.count
        }
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case AddResEnum.restaurant.rawValue:
            let resCell = tableView.dequeueReusableCell(withIdentifier: RestaurantTableViewCell.className, for: indexPath) as! RestaurantTableViewCell
            resCell.delegate = self
            resCell.categoryList = categoryList
            resCell.bindData(restaurant: restaurant)
            return resCell
            
        case AddResEnum.addMenu.rawValue :
            let addMenuCell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.className, for: indexPath) as! MenuTableViewCell
            addMenuCell.delegate = self
            return addMenuCell
            
        case AddResEnum.foodDisplay.rawValue:
            let foodCell = tableView.dequeueReusableCell(withIdentifier: FoodTableViewCell.className, for: indexPath) as! FoodTableViewCell
            foodCell.bindData(data: self.foodModel[indexPath.row])
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
           return 0.48*self.view.frame.height
			
        case AddResEnum.addMenu.rawValue :
            return 0.27*self.view.frame.height
			
        case AddResEnum.foodDisplay.rawValue:
           return 0.1*self.view.frame.height
            
        default:
            return 0
        }
    }
}

extension AddRestaurantVC: RestaurantTableViewCellDelegate, MenuTableViewCellDelegate {
	
	func didClickOnAddButton(food: Food, cell: MenuTableViewCell) {
        let foodRequest = FoodModel(name: food.name, price: food.price, calo: food.calor)
		foodRequest.photo = photoFoodURL
		foodRequest.image = imageFood
        
        self.showLoading()
        RequestManager.addFood(foodRequest: foodRequest) { (result) in
            self.hideLoading()
            if let result = result, !result.isSuccess {
                self.alertMessage(message: result.message)
            }
        }
        
		self.foodModel.append(foodRequest)
		tableView.reloadData()
		
		photoFoodURL = "" // reset photo url
		imageFood = nil// reset image
		cell.resetData()
	}
	
    
    func restaurantTableViewCellEndEditing(restaurantModel: RestaurantRequest) {
        restaurant = restaurantModel
    }
    
    func restaurantTableViewCellDidBeginSearchAddress() {
        let seachAddressVC = GMSAutocompleteViewController()
        seachAddressVC.delegate = self
        present(seachAddressVC, animated: true, completion: nil)
    }
	
	func didAddFoodPhoto() {
		photoType = .food
		openActionSheet()
	}

}

extension AddRestaurantVC: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        restaurant.address = place.formattedAddress ?? ""
        restaurant.lat = place.coordinate.latitude
        restaurant.lng = place.coordinate.longitude
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
    }
    
}

extension AddRestaurantVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }
		
		self.showLoading()

        DispatchQueue.main.async {

            let dataImage = image.jpegData(compressionQuality: 0.05)
            RequestManager.uploadPhoto(dataImage: dataImage!, completion: {  [weak self ](result, error) in

				guard let strongSelf = self, let photoURL = result?.mediaLink else { return }
				strongSelf.hideLoading()

				switch strongSelf.photoType {
				case .food:
					strongSelf.photoFoodURL = photoURL
                    strongSelf.imageFood = image

					let cellMenu = strongSelf.tableView.cellForRow(at: IndexPath.init(row: 0, section: AddResEnum.addMenu.rawValue)) as! MenuTableViewCell
					cellMenu.photoButton.setImage(image, for: .normal)

				case .restaurant:
					strongSelf.restaurant.photo = photoURL
                    DispatchQueue.main.async {
                        strongSelf.headerImageView.image = image
                    }
				}
            })
        }
    }
	
        
}
