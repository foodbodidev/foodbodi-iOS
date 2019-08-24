//
//  VerifyVCViewController.swift
//  FoodBody
//
//  Created by Phuoc on 8/18/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class VerifyVC: BaseVC {
    
    @IBOutlet weak var backButton: UIButton! 

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupLayout()
    }
    
    private func setupLayout() {
        let image = UIImage(named: "backArow")?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(image, for: .normal)
        backButton.tintColor = Style.Color.mainPurple
    }
    
//    @IBAction override func actionBack() {
//        self.navigationController?.popToRootViewController(animated: true)
//    }
}
