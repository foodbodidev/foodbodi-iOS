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
    var idRestaurant:String?
    var listMenu:NSArray?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI();
        // Do any additional setup after loading the view.
    }
    func initUI(){
        self.tbvMenu.register(UINib.init(nibName: "FoodTableViewCell", bundle: nil), forCellReuseIdentifier: "FoodTableViewCell")
        self.tbvMenu!.delegate = self;
        self.tbvMenu!.dataSource = self;
    }

}
extension TabMenuVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return listMenu!.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row;
        
        let foodCell:FoodTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FoodTableViewCell", for: indexPath) as! FoodTableViewCell
        return foodCell;
        
        
    }
}
