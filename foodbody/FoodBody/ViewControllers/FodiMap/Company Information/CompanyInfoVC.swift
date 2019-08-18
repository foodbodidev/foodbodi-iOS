//
//  CompanyInfoVC.swift
//  FoodBody
//
//  Created by Phuoc on 7/26/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit
import GooglePlaces

class CompanyInfoVC: BaseVC {
    @IBOutlet weak var nameTextField: FBTextField!
    @IBOutlet weak var registerTextField: FBTextField!
    @IBOutlet weak var presentationTextField: FBTextField!
    @IBOutlet weak var addressTextField: FBTextField!
    @IBOutlet weak var btnSubmit:UIButton!
    
    let companyInfoRequest = CompanyInfoModel()
    
    @IBOutlet weak var contentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        addressTextField.delegate = self
        setupLayout()
    }
    fileprivate func setupLayout() {
        self.navigationController?.navigationBar.isHidden = false
        nameTextField.textField.placeholder = "Name of company"
        registerTextField.textField.placeholder = "Registration No."
        presentationTextField.textField.placeholder = "Name of representative"
        addressTextField.textField.placeholder = "Address"
    }
    
    @IBAction func actionSubmit() {
        
        guard validateTextFiled() else {
            return
        }
        
        companyInfoRequest.company_name = nameTextField.textField.text ?? ""
        companyInfoRequest.registration_number = registerTextField.textField.text ?? ""
        companyInfoRequest.representative_name = [presentationTextField.textField.text ?? ""]
        companyInfoRequest.address = addressTextField.textField.text ?? ""
        
        self.showLoading()
        
        RequestManager.createRestaurant(request: companyInfoRequest) { (result, error) in
            self.hideLoading()
            if  let result = result{
                if result.isSuccess {
					
					if let user = AppManager.user {
						user.restaurantId = result.id
						AppManager.user = user
					}
                    let verifyVC = VerifyVC.init(nibName: "VerifyVC", bundle: nil)
                    self.navigationController?.pushViewController(verifyVC, animated: true)
                } else {
                    self.alertMessage(message: result.message)
                }
                
            }
            
            if let error = error {
                self.alertMessage(message: error.localizedDescription)
            }
            
        }
    }
    
    
    func validateTextFiled() -> Bool {
        if nameTextField.textField.text!.isEmpty {
            nameTextField.errorLabel.text = "Invalid Name of company"
            nameTextField.showInvalidStatus()
            return false
        }
        
        if registerTextField.textField.text!.isEmpty {
            registerTextField.errorLabel.text = "Registration No."
            registerTextField.showInvalidStatus()
            return false
        }
        
        if presentationTextField.textField.text!.isEmpty  {
            presentationTextField.showInvalidStatus()
            presentationTextField.errorLabel.text = "Invalid Name of representative"
            return false
        }
        
        if addressTextField.textField.text!.isEmpty {
            addressTextField.showInvalidStatus()
            addressTextField.errorLabel.text = "Invalid Address"
            return false
        }
        
        return true
    }
    
    func restaurantTableViewCellDidBeginSearchAddress() {
        let seachAddressVC = GMSAutocompleteViewController()
        seachAddressVC.delegate = self
        present(seachAddressVC, animated: true, completion: nil)
    }

}

extension CompanyInfoVC: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        companyInfoRequest.address = place.formattedAddress ?? ""
        companyInfoRequest.lat = place.coordinate.latitude
        companyInfoRequest.lng = place.coordinate.longitude
        addressTextField.textField.text = place.formattedAddress ?? ""
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

extension CompanyInfoVC: FBTextFieldDelegate {
    func didBeginSearchPlace() {
        addressTextField.resignFirstResponder()
        restaurantTableViewCellDidBeginSearchAddress()
    }
    
    
}
