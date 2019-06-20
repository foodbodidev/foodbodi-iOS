//
//  ProfileVC.swift
//  FoodBody
//
//  Created by Toan Tran on 6/17/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logoutPress(sender:UIButton){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        appDelegate.gotoWelcome();
    }

}
