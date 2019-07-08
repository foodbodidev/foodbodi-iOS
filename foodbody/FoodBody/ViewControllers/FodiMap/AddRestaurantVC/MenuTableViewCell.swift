//
//  MenuTableViewCell.swift
//  FoodBody
//
//  Created by Phuoc on 7/4/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit


struct Menu {
    var title: String = ""
    var price: String = ""
    var calor: String = ""
}


protocol MenuTableViewCellDelegate: class {
    func didClickOnAddButton(menuModel: Menu)
}


class MenuTableViewCell: UITableViewCell {
    
    //MARK: Outlet
    @IBOutlet weak var titleTextField: InforTextField!
    @IBOutlet weak var priceTextField: InforTextField!
    @IBOutlet weak var calorTextField: InforTextField!
    @IBOutlet weak var addMenuButton: FoodBodyButton!
    
    
    
    //MARK: Properties
    weak var delegate: MenuTableViewCellDelegate?
    var model: Menu = Menu()

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
        model.title = titleTextField.text!
        model.price = priceTextField.text!
        model.calor = calorTextField.text!
        
        if let delegate = self.delegate {
            delegate.didClickOnAddButton(menuModel: model)
        }
    }
    
}
