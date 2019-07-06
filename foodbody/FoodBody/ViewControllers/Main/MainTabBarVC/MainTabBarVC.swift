//
//  MainTabBarVC.swift
//  FoodBody
//
//  Created by Toan Tran on 6/17/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class MainTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbarAppearance()

        // Do any additional setup after loading the view.
    }
    
    private func setupTabbarAppearance() {
        
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.07058823529, green: 0.7411764706, blue: 0.462745098, alpha: 1)
        UITabBar.appearance().unselectedItemTintColor = #colorLiteral(red: 0.09803921569, green: 0.2431372549, blue: 0.3215686275, alpha: 1)
        UITabBar.appearance().barTintColor = #colorLiteral(red: 229, green: 237, blue: 229, alpha: 1)
        UITabBar.appearance().isTranslucent = false
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.07058823529, green: 0.7411764706, blue: 0.462745098, alpha: 1),
                                                          NSAttributedString.Key.font: Style.FontStyle.regular.font(with: 12)],
                                                         for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.09803921569, green: 0.2431372549, blue: 0.3215686275, alpha: 1),
                                                          NSAttributedString.Key.font: Style.FontStyle.regular.font(with: 12)],
                                                         for: .normal)
        
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
