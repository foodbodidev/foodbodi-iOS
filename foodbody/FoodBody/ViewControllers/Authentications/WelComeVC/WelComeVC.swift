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
    
    
    //MARK: action.
    @IBAction func actionStart(sender:UIButton){
        FBAppDelegate.gotoMainTab()
        
    }

}
