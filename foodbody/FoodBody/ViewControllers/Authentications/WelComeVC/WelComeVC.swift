//
//  WelComeVC.swift
//  FoodBody
//
//  Created by Toan Tran on 6/18/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class WelComeVC: BaseVC {
    
    //MARK: IBOutlet.
    @IBOutlet weak var btnStart: FoodBodyButton!
    
    //MARK: cycle view.
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.navigationBar.isHidden = true;
    }
    
    
    //MARK: action.
    @IBAction func actionStart(sender:UIButton){
        FBAppDelegate.gotoMainTab()
    }

}
