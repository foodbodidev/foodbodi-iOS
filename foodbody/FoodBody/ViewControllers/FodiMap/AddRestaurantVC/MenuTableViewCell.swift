//
//  MenuTableViewCell.swift
//  FoodBody
//
//  Created by Phuoc on 7/4/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit


struct Food {
    var name: String = ""
    var price: Int = 0
    var calor: Int = 0
	var photo: String = ""
}


protocol MenuTableViewCellDelegate: class {
	func didClickOnAddButton(food: Food, cell: MenuTableViewCell)
	func didAddFoodPhoto()
}


class MenuTableViewCell: UITableViewCell {
    
    //MARK: Outlet
    @IBOutlet weak var titleTextField: InforTextField!
    @IBOutlet weak var priceTextField: InforTextField!
    @IBOutlet weak var calorTextField: InforTextField!
    @IBOutlet weak var addMenuButton: FoodBodyButton!
	@IBOutlet weak var photoButton: UIButton!
    
    
    
    //MARK: Properties
    weak var delegate: MenuTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: Action
    
    @IBAction func actionAddMenu() {
		guard validateData() else {
            self.findViewController()?.alertMessage(message: "Please input full infomation ")
			return
		}
		
		var model: Food = Food()
        model.name = titleTextField.text!
        model.price = Int(priceTextField.text!) ?? 0
        model.calor = Int(calorTextField.text!) ?? 0
        
        if let delegate = self.delegate {
			delegate.didClickOnAddButton(food: model, cell: self)
        }
    }
	
	@IBAction func actionAddPhotoFood() {
		if let delegate = self.delegate {
			delegate.didAddFoodPhoto()
		}
	}
	
	private func validateData() -> Bool {
        if titleTextField.text!.isEmpty {
			return false
		}
		
        if priceTextField.text!.isEmpty {
			return false
		}
		
		if calorTextField.text!.isEmpty {
			return false
		}
		
		return true
	}
    
	func resetData() {
        titleTextField.text = ""
        priceTextField.text = ""
        calorTextField.text = ""
		photoButton.setImage(nil, for: .normal)
    }
    
}
