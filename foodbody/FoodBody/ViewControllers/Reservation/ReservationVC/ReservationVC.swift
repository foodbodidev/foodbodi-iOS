//
//  ReservationVC.swift
//  FoodBody
//
//  Created by Toan Tran on 6/17/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class ReservationVC: UIViewController {
    
    @IBOutlet var tbvReservation:UITableView!
    var listReservation:[ReservationResponse] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI();
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initVar();
    }
    //MARK: init UI.
    func initUI(){
        self.tbvReservation.delegate = self;
        self.tbvReservation.dataSource = self;
    }
    func initVar() {
        FoodbodyUtils.shared.showLoadingHub(viewController: self);
        RequestManager.getListReservation { (result, error) in
            FoodbodyUtils.shared.hideLoadingHub(viewController: self);
            if let error = error {
                self.alertMessage(message: error.localizedDescription)
            }
            if let result = result {
                
                if result.isSuccess {
                    self.listReservation = result.data;
                    self.tbvReservation.reloadData();
                } else {
                    self.alertMessage(message: result.message)
                }
            }
        }
    }
}

extension ReservationVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listReservation.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ReservationCell = tableView.dequeueReusableCell(withIdentifier: "ReservationCell", for: indexPath) as! ReservationCell;
        let obj:ReservationResponse = listReservation[indexPath.row];
        cell.lblName.text = obj.restaurant_name;
        cell.lblCalo.text = String(format:"%d",obj.total);
        let timeInterval:NSInteger = obj.created_date
        cell.lblTime.text = FoodbodyUtils.shared.dateFromTimeInterval(timeInterval: timeInterval)
        return cell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150;
    }
}


