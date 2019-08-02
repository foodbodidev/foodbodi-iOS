//
//  CartRestaurantVC.swift
//  FoodBody
//
//  Created by Toan Tran on 8/2/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class CartRestaurantVC: UIViewController {
//    let foodCart:FoodModel = FoodModel();
    @IBOutlet weak var tbvCart: UITableView!
    var listCart:NSMutableArray = NSMutableArray.init();
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbvCart.delegate = self;
        self.tbvCart.dataSource = self;
    }
}

extension CartRestaurantVC:UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
           return 10;
        }else if section == 1 {
            return 1;
        }
        return 0;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section;
        if section == 0 {
            let cell:CartInfoCell = tableView.dequeueReusableCell(withIdentifier: "CartInfoCell", for: indexPath) as! CartInfoCell
            return cell;
        }else{
            let cell:TotalKcalCell = tableView.dequeueReusableCell(withIdentifier: "TotalKcalCell", for: indexPath) as! TotalKcalCell;
            return cell;
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section;
        if section == 0 {
            return 150;
        }else if section == 1 {
            return 90;
        }
        return 0;
    }

}
