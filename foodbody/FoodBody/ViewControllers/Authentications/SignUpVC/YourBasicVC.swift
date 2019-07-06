//
//  YourBasicVC.swift
//  FoodBody
//
//  Created by Phuoc on 6/25/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class YourBasicVC: BaseVC {
    
    @IBOutlet weak var ageTextField: FBTextField!
    @IBOutlet weak var heightTextField: FBTextField!
    @IBOutlet weak var weightTextField: FBTextField!
    @IBOutlet weak var goalWeightTextField: FBTextField!
    
    var userInfo: UserRequest = UserRequest()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        ageTextField.textField.placeholder = "Your age"
        ageTextField.textField.keyboardType = .numberPad
        
        heightTextField.textField.placeholder = "Your height"
        heightTextField.textField.clearButtonMode = .never
        heightTextField.textField.keyboardType = .numberPad
        
        
        weightTextField.textField.placeholder = "Your weight"
        weightTextField.textField.keyboardType = .numberPad
        weightTextField.textField.clearButtonMode = .never
        
        
        goalWeightTextField.textField.placeholder = "Goal weight"
        goalWeightTextField.textField.keyboardType = .numberPad
        
        
    }
    
    
    @IBAction func actionNext() {
        
        if validateTextFiled() {
           updateUserProfile()
        }
    }
    
    private func updateUserProfile() {
        self.showLoading()
        
        userInfo.age = Int(ageTextField.textField.text!) ?? 0
        userInfo.height = Int(heightTextField.textField.text!) ?? 0
        userInfo.weight = Int(weightTextField.textField.text!) ?? 0
        userInfo.target_weight = Int(goalWeightTextField.textField.text!) ?? 0
        
        RequestManager.updateUserProfile(request: userInfo ) { (result, error) in
            
            self.hideLoading()
            if let error = error {
                self.alertMessage(message: error.localizedDescription)
            }
            
            guard let result = result else { return }
            
            if result.isSuccess {
                FBAppDelegate.gotoMainTab()
            } else {
                self.alertMessage(message: result.message)
            }
        }
    }


    func validateTextFiled() -> Bool {
        if ageTextField.textField.text!.isEmpty {
            ageTextField.errorLabel.text = "Invalid age"
            ageTextField.showInvalidStatus()
        }
        
        if ageTextField.textField.text!.isEmpty {
            ageTextField.errorLabel.text = "Invalid last height"
            ageTextField.showInvalidStatus()
            return false
        }
        
        if weightTextField.textField.text!.isEmpty {
            weightTextField.showInvalidStatus()
            weightTextField.errorLabel.text = "Invalid weight"
            return false
        }
        
        if goalWeightTextField.textField.text!.isEmpty {
            goalWeightTextField.showInvalidStatus()
            goalWeightTextField.errorLabel.text = "Invalid goal weight"
            return false
        }
        
        return true
    }

}
