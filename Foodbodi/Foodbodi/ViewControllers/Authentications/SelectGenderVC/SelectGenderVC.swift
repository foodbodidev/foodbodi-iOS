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
        
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: action.
    @IBAction func actionMale(sender:UIButton){
        self.gotoLogin(gender: "")
    }
    @IBAction func actionFemale(sender:UIButton){
        self.gotoLogin(gender: "")
    }
    
    func gotoLogin(gender:String) -> Void {
        let loginVC = getViewController(className: LoginVC.className, storyboard:FbConstants.AuthenticationSB)
        self.navigationController?.pushViewController(loginVC, animated: true)
    }


}
