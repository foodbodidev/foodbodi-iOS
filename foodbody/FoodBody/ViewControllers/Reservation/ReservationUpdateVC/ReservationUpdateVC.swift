//
//  ReservationUpdateVC.swift
//  FoodBody
//
//  Created by Toan Tran on 8/7/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class ReservationUpdateVC: BaseVC, CartInfoCellDelegate{
    //MARK: variable.
    var reservationId:String = ""
    var totalCalo:CGFloat = 0;
    var listMenu: [FoodModel] = []
    var reservationModel:OneReservationModel = OneReservationModel()
    
    @IBOutlet weak var tbvCart: UITableView!
    @IBOutlet weak var btnUpdateReservation:UIButton!
    
    //MARK: cycle view.
    override func viewDidLoad() {
        super.viewDidLoad();
        self.initUI();
        self.initVar();
    }
    //MARK: init UI.
    func initUI(){
        self.tbvCart.delegate = self;
        self.tbvCart.dataSource = self;
        self.tbvCart.register(UINib.init(nibName: "CartInfoCell", bundle: nil), forCellReuseIdentifier: "CartInfoCell")
        self.tbvCart.register(UINib.init(nibName: "TotalKcalCell", bundle: nil), forCellReuseIdentifier: "TotalKcalCell")
    }
    func initVar() {
        FoodbodyUtils.shared.showLoadingHub(viewController: self);
        RequestManager.getOneReservationWithId(id: self.reservationId) { (result, error) in
            FoodbodyUtils.shared.hideLoadingHub(viewController: self)
            if let error = error {
                self.alertMessage(message: error.localizedDescription)
                return;
            }
            if let result = result {
                
                if result.isSuccess {
                    self.reservationModel = result;
                    for obj in self.reservationModel.reservation.foods{
                        let food: FoodModel = self.reservationModel.foods[obj.food_id]!;
                        food.amount = obj.amount;
                        self.listMenu.append(food)
                    }
                    self.tbvCart.reloadData();
                } else {
                    self.alertMessage(message: result.message)
                }
            }
        }
    }
    //MARK: CartInfoCellDelegate
    func CartInfoCellDelegate(cell: CartInfoCell, actionAdd: UIButton) {
        let indexPath:IndexPath = self.tbvCart.indexPath(for: cell)!;
        let row = indexPath.row
        let data:FoodModel = self.listMenu[row]
        data.amount = data.amount + 1
        self.tbvCart.reloadData()
    }
    func CartInfoCellDelegate(cell: CartInfoCell, actionSub: UIButton) {
        let indexPath:IndexPath = self.tbvCart.indexPath(for: cell)!
        let row = indexPath.row
        let data:FoodModel = self.listMenu[row]
        if data.amount > 0 {
            data.amount = data.amount - 1
            self.tbvCart.reloadData()
        }
    }
    func getTotalCalo()->CGFloat{
        var totalData:CGFloat = 0
        for food in listMenu {
            let totalCaloOneFood = food.amount * food.calo;
            totalData = totalData + CGFloat(totalCaloOneFood)
        }
        return CGFloat(totalData);
    }
    //MARK: IBAction.
    @IBAction func actionUpdateReservation(sender:UIButton){
        if (AppManager.user?.token.isEmpty)! {
            self.alertMessage(message: "You'll need to log in before you can use this feature!")
            return;
        }
        let request = ReservationRequest()
        request.reservationId = self.reservationId;
        request.date_string = FoodbodyUtils.shared.dateStringFromDate(date: Date() as NSDate);
        let foodReservation = listMenu.map({
            return FoodReservationModel(food_id: $0.id, amount: $0.amount)
        })
        
        // ===
        request.foods = foodReservation
        FoodbodyUtils.shared.showLoadingHub(viewController: self);
        RequestManager.updateReservation(foodRequest: request) { (result, error) in
            FoodbodyUtils.shared.hideLoadingHub(viewController: self);
            if let error = error {
                self.alertMessage(message: error.localizedDescription)
            }
            if let result = result {
                if result.isSuccess {
                NotificationCenter.default.post(name:.kFb_update_reservation, object: nil, userInfo:nil);
                    let alert = UIAlertController(title:nil, message: "Update reservation success", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default) {
                        UIAlertAction in
                        //go to company information.
                        self.navigationController?.popToRootViewController(animated: true);
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    self.alertMessage(message: result.message)
                }
            }
        }
    }
}
extension ReservationUpdateVC:UITableViewDataSource, UITableViewDelegate{
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
            cell.lblAmount.text = String(format: "%d", data.amount)
            totalCalo = totalCalo + CGFloat(data.amount * data.calo)
            cell.delegate = self
            return cell
        }else{
            let cell:TotalKcalCell = tableView.dequeueReusableCell(withIdentifier: "TotalKcalCell", for: indexPath) as! TotalKcalCell
            totalCalo = 0
            totalCalo = self.getTotalCalo();
            cell.lblTotal.text = String(format: "%.f", totalCalo)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        if section == 0 {
            return 150;
        }else if section == 1 {
            return 90;
        }
        return 0;
    }
    
}
