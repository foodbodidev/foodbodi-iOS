//
//  CartRestaurantVC.swift
//  FoodBody
//
//  Created by Toan Tran on 8/2/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class CartRestaurantVC: UIViewController, CartInfoCellDelegate {

    @IBOutlet weak var tbvCart: UITableView!
    @IBOutlet weak var btnReservation:UIButton!
    var totalCalo:CGFloat = 0;
    
    var listMenu: [FoodModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbvCart.delegate = self;
        self.tbvCart.dataSource = self;
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.navigationBar.isHidden = true;
    }
    //MARK: IBAction.
    @IBAction func backAction(sender:UIButton){
        self.navigationController?.popViewController(animated: true);
    }
    //MARK: CartInfoCellDelegate
    func CartInfoCellDelegate(cell: CartInfoCell, actionAdd: UIButton) {
        let indexPath:IndexPath = self.tbvCart.indexPath(for: cell)!;
        let row = indexPath.row
        let data:FoodModel = self.listMenu[row]
        data.amount = data.amount + 1;
        totalCalo = totalCalo + CGFloat(data.amount + data.calo);
        self.tbvCart.reloadData();
    }
    func CartInfoCellDelegate(cell: CartInfoCell, actionSub: UIButton) {
        let indexPath:IndexPath = self.tbvCart.indexPath(for: cell)!;
        let row = indexPath.row
        let data:FoodModel = self.listMenu[row]
        if data.amount > 0 {
            data.amount = data.amount - 1;
            totalCalo = totalCalo + CGFloat(data.amount + data.calo);
            self.tbvCart.reloadData();
        }
    }
    
    @IBAction func btnReservation(sender:UIButton){
        let request = ReservationRequest()
        request.restaurant_id = (listMenu.first?.restaurant_id)!;
        let foodReservation = listMenu.map({
            return FoodReservationModel(food_id: $0.id, amount: $0.amount)
        })
        
        // === 
        request.foods = foodReservation
        FoodbodyUtils.shared.showLoadingHub(viewController: self);
        RequestManager.addReservation(foodRequest: request) { (result,error) in
            FoodbodyUtils.shared.hideLoadingHub(viewController: self);
            if let error = error {
                self.alertMessage(message: error.localizedDescription)
            }
            if let result = result {
                
                if result.isSuccess {
                   self.alertMessage(message: "add reservation success")
                    
                } else {
                    self.alertMessage(message: result.message)
                }
            }
        }
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
            cell.lblAmount.text = String(format: "%d", data.amount);
            cell.delegate = self;
            return cell;
        }else{
            let cell:TotalKcalCell = tableView.dequeueReusableCell(withIdentifier: "TotalKcalCell", for: indexPath) as! TotalKcalCell;
            cell.lblTotal.text = String(format: "%.f", totalCalo);
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
