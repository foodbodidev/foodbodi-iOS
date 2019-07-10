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
    var price: String = ""
    var calor: String = ""
}


protocol MenuTableViewCellDelegate: class {
    func didClickOnAddButton(food: Food)
}


class MenuTableViewCell: UITableViewCell {
    
    //MARK: Outlet
    @IBOutlet weak var titleTextField: InforTextField!
    @IBOutlet weak var priceTextField: InforTextField!
    @IBOutlet weak var calorTextField: InforTextField!
    @IBOutlet weak var addMenuButton: FoodBodyButton!
    
    
    
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
			return
		}
		
		var model: Food = Food()
        model.name = titleTextField.text!
        model.price = priceTextField.text!
        model.calor = calorTextField.text!
        
        if let delegate = self.delegate {
            delegate.didClickOnAddButton(food: model)
        }
        
        resetData()
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
    
    private func resetData() {
        titleTextField.text = ""
        priceTextField.text = ""
        calorTextField.text = ""
    }
    
}
