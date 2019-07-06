//
//  SelectGenderVC.swift
//  FoodBody
//
//  Created by Toan Tran on 6/19/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class SelectGenderVC: BaseVC {

    @IBOutlet weak var btnMale:UIButton!
    @IBOutlet weak var btnFemale:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
       
    }
    //MARK: init.
    func initUI() -> Void {
        btnMale.layer.cornerRadius = FbConstants.crRadius
        btnMale.layer.borderWidth = 1
        btnFemale.layer.cornerRadius = FbConstants.crRadius
        btnFemale.layer.borderWidth = 1
    }
    
    //MARK: action.
    @IBAction func actionMale(sender:UIButton){
        self.gotoBasicInfo(gender: "MALE")
    }

    @IBAction func actionFemale(sender:UIButton){
        self.gotoBasicInfo(gender: "FEMALE")
    }
    
    func gotoBasicInfo(gender: String) {
        let yourbasicVC = YourBasicVC.init(nibName: YourBasicVC.className, bundle: nil)
        
        yourbasicVC.userInfo.sex = gender
        self.navigationController?.pushViewController(yourbasicVC, animated: true)
    }


}
