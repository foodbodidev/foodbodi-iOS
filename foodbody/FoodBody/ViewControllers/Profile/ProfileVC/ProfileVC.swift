//
//  ProfileVC.swift
//  FoodBody
//
//  Created by Toan Tran on 6/17/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit


class ProfileVC: UIViewController {
    
    @IBOutlet weak var stepView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    
    private func setupLayout() {
       stepView.layer.borderColor = Style.Color.showDowColor.cgColor
       stepView.layer.borderWidth = 1
    }
    

    @IBAction func logoutPress(sender:UIButton){
        AppManager.user = nil
        FBAppDelegate.gotoWelcome()
    }

}


