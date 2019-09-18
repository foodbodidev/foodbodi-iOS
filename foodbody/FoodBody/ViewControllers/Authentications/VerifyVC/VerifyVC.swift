//
//  VerifyVCViewController.swift
//  FoodBody
//
//  Created by Phuoc on 8/18/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class VerifyVC: BaseVC {
    @IBOutlet var btnContinues:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    private func setupLayout() {
        btnContinues.layer.cornerRadius = 27
        btnContinues.clipsToBounds = true
        btnContinues.layer.borderWidth = 1
        btnContinues.layer.borderColor = UIColor(red: 25, green: 62, blue: 82).cgColor
    }
    
    @IBAction func actionContinues() {
        self.navigationController?.popToRootViewController(animated: true);
    }
}
