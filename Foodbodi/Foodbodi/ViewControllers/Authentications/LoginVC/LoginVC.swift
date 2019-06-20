//
//  LoginVC.swift
//  FoodBody
//
//  Created by Toan Tran on 6/17/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    //MARK: cycle view.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: action
    @IBAction func loginPress(sender:UIButton){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        appDelegate.gotoMainTab();
    }
    @IBAction func signUpPress(sender:UIButton){
        let signupVC = getViewController(className: SignUpVC.className, storyboard:FbConstants.AuthenticationSB);
        self.navigationController?.pushViewController(signupVC, animated: true);
        
    }

}
