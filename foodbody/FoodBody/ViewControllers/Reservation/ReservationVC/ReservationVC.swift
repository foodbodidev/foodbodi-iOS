//
//  ReservationVC.swift
//  FoodBody
//
//  Created by Toan Tran on 6/17/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class ReservationVC: BaseVC {
    
    @IBOutlet var tbvReservation:UITableView!
    var listReservation:[ReservationResponse] = [];
    var cursor:String = "";
    var isLoadingNextPage:Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI();
        self.initVar();
        self.title = "Reservation";
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerNotification();
    }
    func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveUpdateReservation(_:)), name: .kFb_update_reservation, object:nil)
    }
    @objc func onDidReceiveUpdateReservation(_ notification: Notification)
    {
        print("update data reservation")
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
            
            RequestManager.getListReservation(cursor:"") { (result, error) in
                FoodbodyUtils.shared.hideLoadingHub(viewController: self);
                if let error = error {
                    self.alertMessage(message: error.localizedDescription)
                }
                if let result = result {
                    
                    if result.isSuccess {
                        self.listReservation.removeAll();
                        self.listReservation = result.data;
                        for obj in result.data {
                            obj.created_date = obj.created_date/1000;
                            let date:String = FoodbodyUtils.shared.dateFromTimeInterval(timeInterval: obj.created_date);
                            obj.sCreateDate = date;
                        }
                        self.cursor = result.cursor;
                        self.isLoadingNextPage = true;
                        self.tbvReservation.reloadData();
                    } else {
                        self.alertMessage(message: result.message)
                    }
                }
            }
        }
    }
}

extension ReservationVC: UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate{
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
        cell.lblCalo.text = String(format:"%d kcal",obj.total);
        cell.lblTime.text = obj.sCreateDate;
        
        let dateNow = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currectDate = formatter.string(from: dateNow)
        if obj.sCreateDate != currectDate {
            cell.viBoder.backgroundColor = UIColor.white;
        }else{
            cell.viBoder.backgroundColor = UIColor.white;
        }
        //color
        if obj.total < Int(FbConstants.lowCalo) {
            cell.lblCalo.backgroundColor = UIColor.lowKcalColor()
        }else if obj.total >= Int(FbConstants.lowCalo) && obj.total < Int(FbConstants.highCalo) {
            cell.lblCalo.backgroundColor = UIColor.mediumKcalColor();
        }else if obj.total >= Int(FbConstants.highCalo) {
            cell.lblCalo.backgroundColor = UIColor.highKcalColor();
        }
        return cell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj:ReservationResponse = listReservation[indexPath.row];
        let dateNow = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currectDate = formatter.string(from: dateNow)
        if obj.sCreateDate != currectDate {
            self.alertMessage(message: "You are only allowed to update today records");
        }else{
            let vc:ReservationUpdateVC = getViewController(className: ReservationUpdateVC.className, storyboard:FbConstants.ReservationSB) as! ReservationUpdateVC;
            vc.reservationId = obj.id;
            self.navigationController?.pushViewController(vc, animated: true);
        }
    }
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.isLoadingNextPage == true {
            let contentLarger = (scrollView.contentSize.height > scrollView.frame.size.height)
            let viewableHeight = contentLarger ? scrollView.frame.size.height : scrollView.contentSize.height
            let atBottom = (scrollView.contentOffset.y >= scrollView.contentSize.height - viewableHeight + 50)
            if atBottom && !self.tbvReservation.isLoadingFooterShowing() {
                self.tbvReservation.showLoadingFooter()
                RequestManager.getListReservation(cursor:cursor) { (result, error) in
                    self.tbvReservation.hideLoadingFooter();
                    if let error = error {
                        self.alertMessage(message: error.localizedDescription)
                    }
                    if let result = result {
                        
                        if result.isSuccess {
                            var data: [ReservationResponse] = []
                            data = result.data;
                            if (self.cursor == result.cursor){
                                self.isLoadingNextPage = false;
                                return;
                            }else{
                                if data.count == 0{
                                    self.isLoadingNextPage = false;
                                    return;
                                }
                                self.cursor = result.cursor;
                                if data.count > 0{
                                    for obj in data {
                                        self.listReservation.append(obj);
                                    }
                                    self.tbvReservation.reloadData();
                                }
                            }
                        } else {
                            self.alertMessage(message: result.message)
                        }
                    }
                }
            }
        }
    }
}


