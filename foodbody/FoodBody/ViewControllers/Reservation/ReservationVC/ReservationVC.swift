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
        if AppManager.user?.token.isEmpty == false {
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
        //color
        if obj.total < Int(FbConstants.lowCalo) {
            cell.lblCalo.backgroundColor = UIColor.init(rgb: 0xfbd402)
        }else if obj.total >= Int(FbConstants.lowCalo) && obj.total < Int(FbConstants.highCalo) {
            cell.lblCalo.backgroundColor = UIColor.init(rgb: 0x7398de);
        }else if obj.total >= Int(FbConstants.highCalo) {
            cell.lblCalo.backgroundColor = UIColor.init(rgb: 0xeb6d4a);
        }
        return cell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc:ReservationUpdateVC = getViewController(className: ReservationUpdateVC.className, storyboard:FbConstants.ReservationSB) as! ReservationUpdateVC;
        let obj:ReservationResponse = listReservation[indexPath.row];
        vc.reservationId = obj.id;
        vc.restaurantId = obj.restaurant_id;
        self.navigationController?.pushViewController(vc, animated: true);
    }
}


