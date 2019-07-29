//
//  TabChatVC.swift
//  FoodBody
//
//  Created by Toan Tran on 7/15/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit
import Firebase

class TabChatVC: BaseVC {
    @IBOutlet weak var tvChat: UITextView!
    @IBOutlet weak var tbvChat: UITableView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnTypeChat: UIButton!
    
    var listChat: [CommentRestaurantModel] = [];
    let db = Firestore.firestore();
    var restaurantId:String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI();
        self.initData();
    }
    //MARK: init
    func initUI(){
        self.tbvChat.delegate = self;
        self.tbvChat.dataSource = self;
        self.tbvChat.estimatedRowHeight = 0;
        self.tbvChat.rowHeight = UITableView.automaticDimension;
        self.tvChat.layer.cornerRadius = 10;
        self.tvChat.delegate = self;
        self.tvChat.layer.masksToBounds = true;
        self.btnSend.layer.cornerRadius = 10;
        self.btnSend.layer.masksToBounds = true;
        disableBtnSend()
        btnTypeChat.roundCorners(corners: [.topLeft,.bottomLeft, .bottomRight], radius: 15);
    }
    func initData(){
        FoodbodyUtils.shared.showLoadingHub(viewController:self);
        
        db.collection("comments").whereField("restaurant_id", isEqualTo: restaurantId).getDocuments { (querySnapshot, error) in
            FoodbodyUtils.shared.hideLoadingHub(viewController: self);
            if let err = error {
                FoodbodyUtils.shared.hideLoadingHub(viewController: self);
                self.alertMessage(message: "Error getting documents \(err.localizedDescription)")
            } else {
                
                print(  querySnapshot!.documents.count);
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let obj:CommentRestaurantModel = CommentRestaurantModel();
                    let dict:NSDictionary = document.data() as NSDictionary;
                    obj.creator = FoodbodyUtils.shared.checkDataString(dict: dict as NSDictionary, key: "creator")
                    obj.message = FoodbodyUtils.shared.checkDataString(dict: dict as NSDictionary, key: "message")
                    obj.created_date = FoodbodyUtils.shared.checkDataString(dict: dict as NSDictionary, key: "created_date")
                    obj.restaurant_id = FoodbodyUtils.shared.checkDataString(dict: dict as NSDictionary, key: "restaurant_id")
                    self.listChat.append(obj)
                }
                self.tbvChat.reloadData();
            }
        }
    }
    //MARK: UIAction.
    @IBAction func sendAction(sender:UIButton){
        print(tvChat.text as Any);
        //send data
        let commentInfo: CommentRequest = CommentRequest()
        commentInfo.restaurant_id = self.restaurantId;
        commentInfo.message = tvChat.text;
        FoodbodyUtils.shared.showLoadingHub(viewController: self);
        RequestManager.addCommentRestaurant(request: commentInfo) { (result, error) in
            FoodbodyUtils.shared.hideLoadingHub(viewController: self);
            if let error = error {
                self.alertMessage(message: error.localizedDescription)
            }
            if let result = result {
                
                if result.isSuccess {
                    let obj:CommentRestaurantModel = CommentRestaurantModel();
                    obj.message = result.message;
                    obj.created_date = result.created_date;
                    obj.restaurant_id = result.restaurant_id;
                    obj.creator = result.creator;
                    self.listChat.insert(obj, at:0);
                    self.tbvChat.reloadData();
                } else {
                    self.alertMessage(message: result.message)
                }
            }
        }
        
    }
    func enableBtnSend(){
        self.btnSend.backgroundColor = Style.Color.mainGreen;
        self.btnSend.isEnabled = true;
    }
    func disableBtnSend(){
        self.btnSend.backgroundColor = Style.Color.mainGray;
        self.btnSend.isEnabled = true;
    }
    
}

//MARK:UITableViewDelegate, UITableViewDataSource

extension TabChatVC:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listChat.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ChatTbvCell = tableView.dequeueReusableCell(withIdentifier: "ChatTbvCell", for: indexPath) as! ChatTbvCell;
        let obj:CommentRestaurantModel = listChat[indexPath.row]
        if obj.creator.count > 0 {
            if obj.creator == AppManager.user?.email {
                //boss.
                cell.vCustomer.isHidden = true;
                cell.vBoss.isHidden = false;
                cell.lblChatBoss.text = obj.message;
                cell.lblTimeBoss.text = obj.created_date
            }else{
                cell.vCustomer.isHidden = false;
                cell.vBoss.isHidden = true;
                cell.lblChatCustomer.text = obj.message;
                cell.lblTimeBoss.text = obj.created_date;
            }
            
        }
        
        return cell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
}

//MARK:UITextView
extension TabChatVC:UITextViewDelegate{
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool{
        //write document.
        if textView.text.count > 0{
            enableBtnSend()
        }else{
            disableBtnSend()
        }
        return true;
    }
}


