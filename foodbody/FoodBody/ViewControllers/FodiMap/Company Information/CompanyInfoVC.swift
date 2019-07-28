//
//  CompanyInfoVC.swift
//  FoodBody
//
//  Created by Phuoc on 7/26/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class CompanyInfoVC: BaseVC {
    
    @IBOutlet weak var contentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()

        // Do any additional setup after loading the view.
    }
    
    private func setupLayout() {
         self.navigationController?.navigationBar.isHidden = false
         contentView.addShadowforview(color: Style.Color.showDowColor)
         self.title = "Information"
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
