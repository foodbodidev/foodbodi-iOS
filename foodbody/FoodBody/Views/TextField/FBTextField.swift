//
//  FBTextField.swift
//  FoodBody
//
//  Created by Phuoc on 6/22/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class FBTextField: UIView {
    
    @IBOutlet weak var textField: TextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        Bundle.main.loadNibNamed("FBTextField", owner: self, options: nil)
        contentView.frame = self.bounds
        addSubview(contentView)
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(red: 185, green: 194, blue: 196).cgColor
        textField.layer.cornerRadius = 8
        textField.font = UIFont.sfProTextLight(16)
        errorLabel.font = UIFont.sfProTextLight(10)
        errorLabel.isHidden = true
        
    }
    
    func showInvalidStatus() {
        self.errorLabel.isHidden = false
        self.textField.layer.borderColor = UIColor(red: 235, green: 109, blue: 74).cgColor
    }
    
}

extension FBTextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(red: 185, green: 194, blue: 196).cgColor
        self.errorLabel.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(red: 185, green: 194, blue: 196).cgColor
        self.errorLabel.isHidden = true
    }
}

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 20)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
