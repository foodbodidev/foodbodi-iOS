//
//  AddRestaurantVC.swift
//  FoodBody
//
//  Created by Toan Tran on 7/4/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit
import GooglePlaces
import INSPhotoGallery
import Kingfisher

class AddRestaurantVC: BaseVC {
    
    //MARK: ==== OUTLET ====
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var clvHeader: UICollectionView!
    @IBOutlet weak var pageClvIndicator: UIPageControl!;
    
    //MARK: Properties
	var restaurant: RestaurantRequest = RestaurantRequest()
    var foodModel: [FoodModel] = []
	var photoFoodURL: String = ""
    var imagePicker = UIImagePickerController()
    var imageFood: UIImage?
    var listPhotoRestaurant:NSMutableArray = NSMutableArray.init();
    //for photo header
    lazy var headerPhoto: [INSPhotoViewable] = {
        return [
            INSPhoto(imageURL: URL.init(string: restaurant.photo), thumbnailImage: nil)
        ]
    }()
    
    var useCustomOverlay = false
	
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
        registerNib()
        bindDataFromMyRestaurant()
        getFoodByResId()
        self.clvHeader.delegate = self;
        self.clvHeader.dataSource = self;
        
    }
	
    //MARK: === ACTION  ===
	
//    @IBAction func actionBacks() {
//        self.navigationController?.popViewController(animated: true)
//    }
	
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
                           strongSelf.getRestaurantWithProfile(); strongSelf.navigationController?.popToRootViewController(animated: true)
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
    
    @IBAction func previewPhoto() {
        if !restaurant.photo.isEmpty {
            let galleryPreview = INSPhotosViewController(photos: headerPhoto, initialPhoto: headerPhoto.first, referenceView: self.view)
            present(galleryPreview, animated: true, completion: nil)
        } 
    }
	
	//MARK: OTHER METHOD
    
    private func bindDataFromMyRestaurant() {
        guard let myRestaurant = AppManager.restaurant else {
			return
			
		}
        restaurant.mapDataFromMyRestaurant(myRestaurant: myRestaurant)
//        if let photoURL = URL.init(string: restaurant.photo) {
//            headerImageView.kf.setImage(with: photoURL)
//        }
        self.listPhotoRestaurant.add(restaurant.photo);
        self.clvHeader.reloadData();
        self.clvHeader.layoutIfNeeded();
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
    
    private func getFoodByResId() {
        self.showLoading()
        
        RequestManager.getFoodWithRestaurantId(id: AppManager.user?.restaurantId ?? "") { (result, error) in
			self.hideLoading()
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.showLoading()
            let food = foodModel[indexPath.row]
            
            RequestManager.deleteFood(foodRequest: food) { (result) in
                self.hideLoading()
                self.foodModel.remove(at: indexPath.row)
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == AddResEnum.foodDisplay.rawValue {
            return true
        }
        return false
    }
}

extension AddRestaurantVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
            
        case AddResEnum.restaurant.rawValue:
           return 0.3*self.view.frame.height
			
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
        var foodRequest = FoodModel(name: food.name, price: food.price, calo: food.calor)
		foodRequest.photo = photoFoodURL
		foodRequest.image = imageFood
		
        
        self.showLoading()
        RequestManager.addFood(foodRequest: foodRequest) { (result) in
            self.hideLoading()
            if let result = result {
                foodRequest = result
                
                self.foodModel.append(foodRequest)
                self.tableView.reloadData()
                self.photoFoodURL = "" // reset photo url
                self.imageFood = nil// reset image
                cell.resetData()
            }
        }
	}
	
    
    func restaurantTableViewCellEndEditing(restaurantModel: RestaurantRequest) {
        restaurant = restaurantModel
    }
	
	func didAddFoodPhoto() {
		photoType = .food
		openActionSheet()
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
//                    strongSelf.restaurant.photo = photoURL
//                    DispatchQueue.main.async {
//
//                        strongSelf.headerImageView.image = image
//                    }
                    strongSelf.listPhotoRestaurant.add(photoURL);
                    self?.clvHeader.reloadData();
				}
            })
        }
    }
}

extension AddRestaurantVC:UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.pageClvIndicator.numberOfPages = listPhotoRestaurant.count;
        return listPhotoRestaurant.count;
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:RestaurantHeaderClvCell = collectionView.dequeueReusableCell(withReuseIdentifier:"RestaurantHeaderClvCell", for: indexPath) as! RestaurantHeaderClvCell;
        let sUrl = listPhotoRestaurant[indexPath.row];
        if let imageUrl = URL(string:sUrl as? String ?? "") {
            KingfisherManager.shared.retrieveImage(with: imageUrl, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                if image != nil {
                    cell.imgRestaurant.image = image;
                }else{
                    cell.imgRestaurant.image = UIImage.init(named: "ic_placeholder");
                }
            })
        }else{
            cell.imgRestaurant.image = UIImage.init(named: "ic_placeholder");
        }
        return cell;
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.clvHeader {
            self.pageClvIndicator.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        }
    }
    
}
