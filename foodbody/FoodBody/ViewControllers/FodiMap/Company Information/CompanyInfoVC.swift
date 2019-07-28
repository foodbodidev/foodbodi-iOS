//
//  CompanyInfoVC.swift
//  FoodBody
//
//  Created by Phuoc on 7/26/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class CompanyInfoVC: BaseVC {
    @IBOutlet weak var nameTextField: FBTextField!
    @IBOutlet weak var registerTextField: FBTextField!
    @IBOutlet weak var presentationTextField: FBTextField!
    @IBOutlet weak var addressTextField: FBTextField!
    @IBOutlet weak var btnSubmit:UIButton!
    
    @IBOutlet weak var contentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        // Do any additional setup after loading the view.
    }
    fileprivate func setupLayout() {
        self.navigationController?.navigationBar.isHidden = false
        nameTextField.textField.placeholder = "Name of company"
        registerTextField.textField.placeholder = "Registration No."
        presentationTextField.textField.placeholder = "Name of representative"
        addressTextField.textField.placeholder = "Address"
    }

}
