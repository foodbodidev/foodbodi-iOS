//
//  TabChatVC.swift
//  FoodBody
//
//  Created by Toan Tran on 7/15/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class TabChatVC: BaseVC {
    @IBOutlet weak var tvChat: UITextView!
    @IBOutlet weak var tbvChat: UITableView!
    
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
