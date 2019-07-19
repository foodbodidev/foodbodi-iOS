//
//  SignUpVC.swift
//  FoodBody
//
//  Created by Toan Tran on 6/17/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class SignUpVC: BaseLoginVC {

    @IBOutlet weak var firstTextField: FBTextField!
    @IBOutlet weak var lastTextField: FBTextField!
    @IBOutlet weak var emailTextField: FBTextField!
    @IBOutlet weak var passwordTextField: FBTextField!

    var userInfors: UserRequest = UserRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        firstTextField.textField.placeholder = "Firstname"
        lastTextField.textField.placeholder = "Lastname"
        emailTextField.textField.placeholder = "Email"
        passwordTextField.textField.placeholder = "Password"
		passwordTextField.textField.isSecureTextEntry = true
        
    }
    
    @IBAction func actionSignup() {
		
		getDataFromField()
        
        guard validateTextFiled() == true else { return }
        
        userInfors.email = emailTextField.textField.text ?? ""
        userInfors.password = passwordTextField.textField.text ?? ""
        
        showLoading()
		RequestManager.registerWithUserInfo(request: userInfors) { [weak self] (result, error) in

            guard let strongSelf = self else { return }// set weak self to avoid retain cycle

            strongSelf.hideLoading()
            if let error = error {
                strongSelf.alertMessage(message: error.localizedDescription)
            }
            
            if let result = result {
                
                if result.isSuccess {
					strongSelf.alertMessage(message: "You've signed up successfully", completion: {
						strongSelf.navigationController?.popViewController(animated: true)
					})
                } else {
                   strongSelf.alertMessage(message: result.message)
                }
            }
        }
        
       
        
    }
	
	private func getDataFromField() {
		userInfors.firstName = firstTextField.textField.text
		userInfors.lastName = lastTextField.textField.text
		userInfors.email = emailTextField.textField.text
		userInfors.password = passwordTextField.textField.text
	}
    
    func validateTextFiled() -> Bool {
        if firstTextField.textField.text?.count == 0 {
            firstTextField.errorLabel.text = "Invalid first name"
            firstTextField.showInvalidStatus()
            return false
        }
        
        if lastTextField.textField.text?.count == 0 {
            lastTextField.errorLabel.text = "Invalid last name"
            firstTextField.showInvalidStatus()
            return false
        }
        
        if !(emailTextField.textField.text ?? "").isValidEmail  {
            emailTextField.showInvalidStatus()
            emailTextField.errorLabel.text = "Invalid email"
            return false
        }
        
        if passwordTextField.textField.text?.count == 0 {
            passwordTextField.showInvalidStatus()
            passwordTextField.errorLabel.text = "Invalid password"
            return false
        }
        
        return true
    }
    
    
}

