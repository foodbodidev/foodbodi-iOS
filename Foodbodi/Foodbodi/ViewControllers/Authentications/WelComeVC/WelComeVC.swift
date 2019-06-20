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
    @IBOutlet weak var btnStart:UIButton!
    
    //MARK: cycle view.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //MARK: action.
    @IBAction func actionStart(sender:UIButton){
        let selectGenderVC = getViewController(className: SelectGenderVC.className, storyboard:FbConstants.AuthenticationSB)
        self.navigationController?.pushViewController(selectGenderVC, animated: true)
    }

}
