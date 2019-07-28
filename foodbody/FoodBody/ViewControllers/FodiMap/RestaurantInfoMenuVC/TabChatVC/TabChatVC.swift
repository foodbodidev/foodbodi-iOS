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
    
    var listRestaurant: [QueryDocumentSnapshot] = [];
    let db = Firestore.firestore();
    var restaurantId:String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI();
    }
    //MARK: init
    func initUI(){
        self.tbvChat.delegate = self;
        self.tbvChat.dataSource = self;
        self.tbvChat.estimatedRowHeight = 60;
        self.tbvChat.rowHeight = UITableView.automaticDimension;
        tvChat.layer.cornerRadius = 10;
    }
    func initData(){
        FoodbodyUtils.shared.showLoadingHub(viewController:self);
        
        db.collection("comments").whereField("restaurant_id", isEqualTo: restaurantId).getDocuments { (result, error) in
            FoodbodyUtils.shared.hideLoadingHub(viewController: self);
            
            if let err = error {
                FoodbodyUtils.shared.hideLoadingHub(viewController: self);
                self.alertMessage(message: "Error getting documents \(err.localizedDescription)")
            } else {
                
//                print(  querySnapshot!.documents.count);
//                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                    self.listRestaurant.append(document)
//                }
//                self.showDataOnMapWithCurrentLocation(curentLocation: self.currentLocation)
//                self.clvFodi.reloadData();
//                self.stopAnimationLoading()
                
            }
        }
    }

}

extension TabChatVC:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatCell:ChatTbvCell = tableView.dequeueReusableCell(withIdentifier: "ChatTbvCell", for: indexPath) as! ChatTbvCell;
        
        return chatCell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
    
    
}
