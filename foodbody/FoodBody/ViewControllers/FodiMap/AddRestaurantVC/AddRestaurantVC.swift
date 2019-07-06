//
//  AddRestaurantVC.swift
//  FoodBody
//
//  Created by Toan Tran on 7/4/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit


enum AddResEnum: Int, CaseIterable {
    case restaurant = 0
    case addMenu
    case foodDisplay
}

class AddRestaurantVC: BaseVC {
    
    //MARK: ==== Outlet ====
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

        registerNib()
    }
        
    private func registerNib() {
        tableView.register(UINib.init(nibName: MenuTableViewCell.className, bundle: nil), forCellReuseIdentifier: MenuTableViewCell.className)
        tableView.register(UINib.init(nibName: FoodTableViewCell.className, bundle: nil), forCellReuseIdentifier: FoodTableViewCell.className)
        tableView.register(UINib.init(nibName: RestaurantTableViewCell.className, bundle: nil), forCellReuseIdentifier: RestaurantTableViewCell.className)
        
    }
    

    //MARK: === Action ===
    
    @IBAction func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }

}


extension AddRestaurantVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return AddResEnum.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case AddResEnum.restaurant.rawValue:
            let resCell = tableView.dequeueReusableCell(withIdentifier: RestaurantTableViewCell.className, for: indexPath)
            return resCell
            
        case AddResEnum.addMenu.rawValue :
            let addMenuCell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.className, for: indexPath)
            return addMenuCell
            
        case AddResEnum.foodDisplay.rawValue:
            let foodCell = tableView.dequeueReusableCell(withIdentifier: FoodTableViewCell.className, for: indexPath)
            return foodCell
        default:
            return UITableViewCell()
        }
    }
}

extension AddRestaurantVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
            
        case AddResEnum.restaurant.rawValue:
           return 0.339*self.view.frame.height
            
        case AddResEnum.addMenu.rawValue :
            return 200
            
        case AddResEnum.foodDisplay.rawValue:
           return 0.13*self.view.frame.height
            
        default:
            return 0
        }
    }
}
