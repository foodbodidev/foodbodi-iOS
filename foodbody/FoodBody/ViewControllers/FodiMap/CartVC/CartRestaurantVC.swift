//
//  CartRestaurantVC.swift
//  FoodBody
//
//  Created by Toan Tran on 8/2/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class CartRestaurantVC: UIViewController, CartInfoCellDelegate {
//    let foodCart:FoodModel = FoodModel();
    @IBOutlet weak var tbvCart: UITableView!
    var listMenu: [FoodModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbvCart.delegate = self;
        self.tbvCart.dataSource = self;
    }
    //MARK: IBAction.
    @IBAction func backAction(sender:UIButton){
        self.navigationController?.popViewController(animated: true);
    }
    //MARK: CartInfoCellDelegate
    func CartInfoCellDelegate(cell: CartInfoCell, actionAdd: UIButton) {
        
    }
    func CartInfoCellDelegate(cell: CartInfoCell, actionSub: UIButton) {
        
    }
}

extension CartRestaurantVC:UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
           return listMenu.count;
        }else if section == 1 {
            return 1;
        }
        return 0;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section;
        if section == 0 {
            let cell:CartInfoCell = tableView.dequeueReusableCell(withIdentifier: "CartInfoCell", for: indexPath) as! CartInfoCell
            let row = indexPath.row
            let data:FoodModel = self.listMenu[row]
            cell.nameLabel.text = data.name
            cell.priceLabel.text = "\(data.price)" + "$"
            cell.calorLabel.text = "\(data.calo)" + " Kcal"
            if let url = URL.init(string: data.photo) {
                cell.foodImageView.kf.setImage(with: url)
            } else {
                cell.foodImageView.image = nil
            }
            cell.delegate = self;
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
