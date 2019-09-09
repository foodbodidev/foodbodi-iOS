//
//  LoginVC.swift
//  FoodBody
//
//  Created by Toan Tran on 6/17/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: BaseLoginVC {
    
    @IBOutlet weak var emailTextField: FBTextField!
    @IBOutlet weak var passwordTextField: FBTextField!
    
    //MARK: cycle view.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false;
    }
    
    fileprivate func setupLayout() {
        
        emailTextField.textField.placeholder = "Email"
        passwordTextField.textField.placeholder = "Password"
		passwordTextField.textField.isSecureTextEntry = true
        
    }
    
    func validateTextFiled() -> Bool {
        
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
    //MARK: action
    @IBAction func loginPress(sender:UIButton){
        self.view.endEditing(true)
        if self.validateTextFiled() == false {
            return
        }
        
        let email = emailTextField.textField.text ?? ""
        let password = passwordTextField.textField.text ?? ""
        let user = UserRequest(email: email, password: password)
        showLoading()
        
        RequestManager.loginWithUserInfo(request: user) { [weak self] (result, error) in
            guard let strongSelf = self else { return }// set weak self to avoid retain cycle
            
            strongSelf.hideLoading()
            if let error = error {
                strongSelf.alertMessage(message: error.localizedDescription)
            }
            
            guard let result = result else { return }
                
            if result.isSuccess {
				AppManager.user = result
                NotificationCenter.default.post(name:.kFB_notifi_registerRestaurant, object: nil, userInfo:nil);
				strongSelf.getUserProfile()
                strongSelf.getRestaurantWithProfile()
                
            } else {
                strongSelf.alertMessage(message: result.message)
            }
        }
    }
    @IBAction func signUpPress(sender:UIButton){
        let signUpVC = SignUpVC.init(nibName: "SignUpVC", bundle: nil)// just let here temperary
        self.navigationController?.pushViewController(signUpVC, animated: true)
        
    }
    
    //MARK: Other methods.
    func gotoGenderInfo() {
        let selectGenderVC = getViewController(className: SelectGenderVC.className, storyboard: FbConstants.AuthenticationSB)
        self.navigationController?.pushViewController(selectGenderVC, animated: true)
    }

}
