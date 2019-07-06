//
//  AddRestaurantVC.swift
//  FoodBody
//
//  Created by Toan Tran on 7/4/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class AddRestaurantVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

        // Do any additional setup after loading the view.
    }
    

    //MARK: Action
    
    @IBAction func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }

}
