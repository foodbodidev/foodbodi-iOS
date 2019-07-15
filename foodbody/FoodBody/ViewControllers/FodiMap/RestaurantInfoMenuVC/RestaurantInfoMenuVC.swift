//
//  RestaurantInfoMenuVC.swift
//  FoodBody
//
//  Created by Toan Tran on 7/14/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit
import Firebase

class RestaurantInfoMenuVC: BaseVC {
    // MARK: variables
    var document:QueryDocumentSnapshot? = nil
    var listMenu:NSMutableArray?
    var tabMenuVC:TabMenuVC?
    var tabChatVC:TabChatVC?
    weak var navInfoMenu:UINavigationController!
    // MARK: IBOutlet.
    @IBOutlet weak var viContainer:UIView!
    @IBOutlet weak var btnMenu:UIButton!
    @IBOutlet weak var btnChat:UIButton!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblCategory:UILabel!
    @IBOutlet weak var lblKcal:UILabel!
    @IBOutlet weak var lblTime:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI();
        self.initVar();
    }
    //MARK: init.
    func initUI(){
        
    }
    func initVar() {
        if document != nil {
            let dict:NSDictionary = document!.data() as NSDictionary;
            self.lblName.text = FoodbodyUtils.shared.checkDataString(dict: dict, key: "name");
            self.lblCategory.text = FoodbodyUtils.shared.checkDataString(dict: dict, key: "category");
            self.lblKcal.text = "300kcal";
            self.lblTime.text = FoodbodyUtils.shared.checkDataString(dict: dict, key: "open_hour") + "-" + FoodbodyUtils.shared.checkDataString(dict: dict, key: "close_hour");
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nav_info_menu" {
            self.navInfoMenu = (segue.destination as! UINavigationController)
            self.navInfoMenu.navigationBar.isHidden = true;
            self.tabMenuVC = getViewController(className: TabMenuVC.className, storyboard: FbConstants.FodiMapSB) as? TabMenuVC
             self.tabChatVC = getViewController(className: TabChatVC.className, storyboard: FbConstants.FodiMapSB) as? TabChatVC
            self.navInfoMenu.setViewControllers([self.tabMenuVC!], animated: false);
        }
    }
    //MARK: action
    @IBAction func menuAction(sender:UIButton){
        if !self.navInfoMenu.viewControllers.last!.isKind(of: TabMenuVC.self){
            self.navInfoMenu.setViewControllers([self.tabMenuVC!], animated: false);
        }
    }
    @IBAction func chatAction(sender:UIButton){
        if !self.navInfoMenu.viewControllers.last!.isKind(of: TabChatVC.self){
            self.navInfoMenu.setViewControllers([self.tabChatVC!], animated: false);
        }
    }

}
