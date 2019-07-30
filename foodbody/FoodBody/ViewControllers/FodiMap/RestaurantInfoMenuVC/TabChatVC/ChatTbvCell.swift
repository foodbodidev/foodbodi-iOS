//
//  ChatTbvCell.swift
//  FoodBody
//
//  Created by Toan Tran on 7/27/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class ChatTbvCell: UITableViewCell {
    
    @IBOutlet weak var lblChat:UILabel!
//    @IBOutlet weak var lblTime:UILabel!
    @IBOutlet weak var viData:UIView!
    @IBOutlet weak var vContent:UIView!;
    @IBOutlet weak var vICon: UIView!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viData.roundCorners(corners: [.topRight,.bottomLeft, .bottomRight], radius: 15);
        self.vICon.layer.cornerRadius = 5;
    }
}
