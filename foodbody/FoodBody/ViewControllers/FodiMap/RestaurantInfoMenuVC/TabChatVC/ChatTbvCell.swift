//
//  ChatTbvCell.swift
//  FoodBody
//
//  Created by Toan Tran on 7/27/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class ChatTbvCell: UITableViewCell {
    
    @IBOutlet weak var lblChatBoss:UILabel!
    @IBOutlet weak var lblTimeBoss:UILabel!
    @IBOutlet weak var viDataBoss:UIView!
    @IBOutlet weak var vBoss:UIView!;
    
    //left.
    @IBOutlet weak var lblChatCustomer:UILabel!
    @IBOutlet weak var lblTimeCustomer:UILabel!
    @IBOutlet weak var viDataCustomer:UIView!
    @IBOutlet weak var vCustomer:UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viDataBoss.roundCorners(corners: [.topRight,.bottomLeft, .bottomRight], radius: 15);
        self.viDataCustomer.roundCorners(corners: [.topRight,.bottomLeft, .bottomRight], radius: 15);
        
    }
}
