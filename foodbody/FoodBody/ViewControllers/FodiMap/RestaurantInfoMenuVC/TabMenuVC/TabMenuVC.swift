//
//  TabMenuVC.swift
//  FoodBody
//
//  Created by Toan Tran on 7/15/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class TabMenuVC: BaseVC {
    
    @IBOutlet weak var tbvMenu: UITableView!
    var idRestaurant: String = ""
    var listMenu: [FoodModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI();
        // Do any additional setup after loading the view.
        self.getDataFromServer();
    }
    func initUI(){
        self.tbvMenu.register(UINib.init(nibName: "FoodTableViewCell", bundle: nil), forCellReuseIdentifier: "FoodTableViewCell")
        self.tbvMenu.delegate = self
        self.tbvMenu.dataSource = self
    }
    func getDataFromServer() {
        
        listMenu.removeAll()
        FoodbodyUtils.shared.showLoadingHub(viewController: self);
        RequestManager.getFoodWithRestaurantId(id: self.idRestaurant) { (result, error) in
            FoodbodyUtils.shared.hideLoadingHub(viewController: self);
            if let error = error {
                self.alertMessage(message: "Get Data fail \(error.localizedDescription)");
            }
            if let result = result {
                
                if result.isSuccess {
                    for object in result.data{
                        self.listMenu.append(object)
                    }
                    self.tbvMenu.reloadData();
                } else {
                    self.alertMessage(message: result.message)
                }
            }
        }
    }

}
extension TabMenuVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listMenu.count > 0{
            return listMenu.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        let data:FoodModel = self.listMenu[row]
        let foodCell:FoodTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FoodTableViewCell", for: indexPath) as! FoodTableViewCell
        
        foodCell.nameLabel.text = data.name
        foodCell.priceLabel.text = "\(data.price)" + "$"
        foodCell.calorLabel.text = "\(data.calo)" + " Kcal"
        return foodCell;
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80;
    }
    
    
}
