//
//  PopupInputVC.swift
//  FoodBody
//
//  Created by Phuoc on 9/10/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class PopupInputVC: BaseVC {
    
    
    @IBOutlet weak var inPutTextField: FBTextField!
    
    var blockDissmis : ((_ caloriesMax: Int) -> ())?

    override func viewDidLoad() {
        inPutTextField.textField.placeholder = "Input your calories"
        inPutTextField.textField.keyboardType = .decimalPad
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func actionDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionOk() {
        
        if let value = Int(self.inPutTextField.textField.text!), value == 0 {
            self.alertMessage(message: "Please input value greater than 0")
            return
        }
        
        if let value = Int(self.inPutTextField.textField.text!), value >  30000 {
            self.alertMessage(message: "Please input value less than 30000")
            return
        }
        
        
        
         let userInfo: UserRequest = UserRequest()
         userInfo.daily_calo = Int(inPutTextField.textField.text!)
        
        self.showLoading()
        
        RequestManager.updateUserProfile(request: userInfo ) { (result, error) in

            self.hideLoading()
            if let error = error {
                self.alertMessage(message: error.localizedDescription)
            }

            guard let result = result else { return }

            if result.isSuccess {
                self.dismiss(animated: true, completion: nil)
                self.blockDissmis!(Int(self.inPutTextField.textField.text!)!)
            } else {
                self.alertMessage(message: result.message)
            }
        }
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
