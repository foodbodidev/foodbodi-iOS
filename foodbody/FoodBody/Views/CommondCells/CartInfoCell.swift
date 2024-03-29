//
//  CartInfoCell.swift
//  FoodBody
//
//  Created by Toan Tran on 8/2/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit
protocol CartInfoCellDelegate:class {
    func CartInfoCellDelegate(cell: CartInfoCell, actionAdd: UIButton)
    func CartInfoCellDelegate(cell: CartInfoCell, actionSub: UIButton)
}
class CartInfoCell: UITableViewCell {
    //MARK: Outlet
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var calorLabel: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnSub: UIButton!
    @IBOutlet weak var viFood: UIView!
    //MARK: Properties
    weak var delegate: CartInfoCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        foodImageView.layer.masksToBounds = true;
        foodImageView.layer.cornerRadius = 8;
        viFood.layer.masksToBounds = true;
        viFood.layer.cornerRadius = 8;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func addAction(sender:UIButton){
        if let delegate = self.delegate {
            delegate.CartInfoCellDelegate(cell: self, actionAdd: sender);
        }
    }
    @IBAction func subAction(sender:UIButton){
        if let delegate = self.delegate {
            delegate.CartInfoCellDelegate(cell: self, actionSub: sender);
        }
    }

}
