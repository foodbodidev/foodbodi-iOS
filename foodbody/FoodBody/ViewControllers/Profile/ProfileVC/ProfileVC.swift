//
//  ProfileVC.swift
//  FoodBody
//
//  Created by Toan Tran on 6/17/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit
import GooglePlaces

class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func logoutPress(sender:UIButton){
        AppManager.user = nil
        FBAppDelegate.gotoWelcome()
    }

}

extension ProfileVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get the place name from 'GMSAutocompleteViewController'
        // Then display the name in textField
        
        // Dismiss the GMSAutocompleteViewController when something is selected
        print(place.name)
        print((place.coordinate))
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
    }
}

