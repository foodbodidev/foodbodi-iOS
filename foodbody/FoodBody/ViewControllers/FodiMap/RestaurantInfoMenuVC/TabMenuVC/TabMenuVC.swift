//
//  TabMenuVC.swift
//  FoodBody
//
//  Created by Toan Tran on 7/15/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit
import Firebase

class TabMenuVC: BaseVC {
    // MARK: IBOutlet
    @IBOutlet weak var tbvMenu: UITableView!
    //MARK: variable.
    var idRestaurant: String = ""
    var listMenu: [FoodModel] = []
    var listForyou:[FoodModel] = [];
    let db = Firestore.firestore();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI();
        self.getDataFromServer();
    }
    //MARKL: init
    
    func initUI(){
        self.tbvMenu.register(UINib.init(nibName: "FoodTableViewCell", bundle: nil), forCellReuseIdentifier: "FoodTableViewCell")
        self.tbvMenu.delegate = self
        self.tbvMenu.dataSource = self
    }
    
    func getDataFromServer() {
        FoodbodyUtils.shared.showLoadingHub(viewController:self);
        db.collection("foods").whereField("restaurant_id", isEqualTo: idRestaurant).getDocuments { (querySnapshot, error) in
            FoodbodyUtils.shared.hideLoadingHub(viewController: self);
            if let err = error {
                FoodbodyUtils.shared.hideLoadingHub(viewController: self);
                self.alertMessage(message: "Error getting documents \(err.localizedDescription)")
            } else {
                
                print(  querySnapshot!.documents.count);
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let dict:NSDictionary = document.data() as NSDictionary;
                    let name:String = FoodbodyUtils.shared.checkDataString(dict: dict as NSDictionary, key: "name")
                    let price:Double = (FoodbodyUtils.shared.checkDataFloat(dict: dict as NSDictionary, key: "price"))
                    let calo:Double = (FoodbodyUtils.shared.checkDataFloat(dict: dict as NSDictionary, key: "calo"))
                    let obj:FoodModel = FoodModel.init(name: name, price: Double(price), calo: calo);
                    obj.id = document.documentID /// documentId  = foodId
                    obj.creator = FoodbodyUtils.shared.checkDataString(dict: dict as NSDictionary, key: "creator")
                    obj.restaurant_id = FoodbodyUtils.shared.checkDataString(dict: dict as NSDictionary, key: "restaurant_id")
                    obj.photo = FoodbodyUtils.shared.checkDataString(dict: dict as NSDictionary, key: "photo")
                    self.listMenu.append(obj);
                }
                for itemForyou in self.listMenu {
                    if itemForyou.calo <= (AppManager.caloLeft) {
                        self.listForyou.append(itemForyou);
                    }
                }
                print("list for you \(self.listForyou.count)")
                self.tbvMenu.reloadData();
            }
        }
    }

}

extension TabMenuVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40;
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let user = AppManager.user{
            if user.token.count > 0 {
                if section == 0 {
                    let headerView = UIView()
                    headerView.backgroundColor = UIColor.white
                    
                    let sectionLabel = UILabel(frame: CGRect(x: 8, y: 10, width:
                        tableView.bounds.size.width, height: tableView.bounds.size.height))
                    sectionLabel.font = UIFont.sfProTextSemibold(18)
                    sectionLabel.textColor = UIColor.black
                    sectionLabel.text = "For you"
                    sectionLabel.sizeToFit()
                    headerView.addSubview(sectionLabel)
                    return headerView
                }else {
                    let headerView = UIView()
                    headerView.backgroundColor = UIColor.white
                    
                    let sectionLabel = UILabel(frame: CGRect(x: 8, y: 10, width:
                        tableView.bounds.size.width, height: tableView.bounds.size.height))
                    sectionLabel.font = UIFont.sfProTextSemibold(18)
                    sectionLabel.textColor = UIColor.black
                    sectionLabel.text = "Name of foods"
                    sectionLabel.sizeToFit()
                    headerView.addSubview(sectionLabel)
                    return headerView
                }
            }
        }else {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.white
            
            let sectionLabel = UILabel(frame: CGRect(x: 8, y: 10, width:
                tableView.bounds.size.width, height: tableView.bounds.size.height))
            sectionLabel.font = UIFont.sfProTextSemibold(18)
            sectionLabel.textColor = UIColor.black
            sectionLabel.text = "Name of foods"
            sectionLabel.sizeToFit()
            headerView.addSubview(sectionLabel)
            return headerView
        }
        return UIView.init()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if let user = AppManager.user{
            if user.token.count > 0 {
                return 2
            }
        }
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let user = AppManager.user{
            if user.token.count > 0 {
                if section == 0 {
                    return listForyou.count
                } else if (section == 1) {
                     return listMenu.count
                }
            }
        }else {
            return listMenu.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section;
        if let user = AppManager.user{
            if user.token.count > 0 {
                
                if section == 0 {
                    let row = indexPath.row
                    let data:FoodModel = self.listForyou[row]
                    let foodCell:FoodTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FoodTableViewCell", for: indexPath) as! FoodTableViewCell
                    
                    foodCell.nameLabel.text = data.name
                    foodCell.priceLabel.text = "\(data.price)" + "$"
                    foodCell.calorLabel.text = "\(data.calo)" + " Kcal"
                    if let url = URL.init(string: data.photo) {
                        foodCell.foodImageView.kf.setImage(with: url)
                    } else {
                        foodCell.foodImageView.image = nil
                    }
                    return foodCell;
                }else{
                    let row = indexPath.row
                    let data:FoodModel = self.listMenu[row]
                    let foodCell:FoodTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FoodTableViewCell", for: indexPath) as! FoodTableViewCell
                    
                    foodCell.nameLabel.text = data.name
                    foodCell.priceLabel.text = "\(data.price)" + "$"
                    foodCell.calorLabel.text = "\(data.calo)" + " Kcal"
                    if let url = URL.init(string: data.photo) {
                        foodCell.foodImageView.kf.setImage(with: url)
                    } else {
                        foodCell.foodImageView.image = nil
                    }
                    return foodCell;
                }
            }
        }else{
            let row = indexPath.row
            let data:FoodModel = self.listMenu[row]
            let foodCell:FoodTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FoodTableViewCell", for: indexPath) as! FoodTableViewCell
            
            foodCell.nameLabel.text = data.name
            foodCell.priceLabel.text = "\(data.price)" + "$"
            foodCell.calorLabel.text = "\(data.calo)" + " Kcal"
            if let url = URL.init(string: data.photo) {
                foodCell.foodImageView.kf.setImage(with: url)
            } else {
                foodCell.foodImageView.image = nil
            }
            return foodCell;
        }
        return UITableViewCell.init();
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc:CartRestaurantVC = getViewController(className: CartRestaurantVC.className, storyboard: FbConstants.FodiMapSB) as! CartRestaurantVC;
        vc.listMenu = listMenu
        self.parent?.navigationController?.pushViewController(vc, animated: true);
    }
    
    
}
