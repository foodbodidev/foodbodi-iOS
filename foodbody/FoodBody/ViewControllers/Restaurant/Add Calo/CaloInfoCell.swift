//
//  CaloInfoCell.swift
//  FoodBody
//
//  Created by Toan Tran on 9/6/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit
protocol CaloInfoCellDelegate:class {
    func CaloInfoCellDelegate(cell: CaloInfoCell, actionAdd: UIButton)
    func CaloInfoCellDelegate(cell: CaloInfoCell, actionSub: UIButton)
}
class CaloInfoCell: UITableViewCell {
    @IBOutlet var lblCategory:UILabel!
    @IBOutlet var lblENERC_KCAL:UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnSub: UIButton!
    weak var delegate: CaloInfoCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func addAction(sender:UIButton){
        if let delegate = self.delegate {
            delegate.CaloInfoCellDelegate(cell: self, actionAdd: sender);
        }
    }
    @IBAction func subAction(sender:UIButton){
        if let delegate = self.delegate {
            delegate.CaloInfoCellDelegate(cell: self, actionSub: sender);
        }
    }
}
