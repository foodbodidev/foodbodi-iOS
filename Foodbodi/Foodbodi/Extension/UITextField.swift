//
//  UITextField.swift
//  NEO
//
//  Created by Phuoc on 3/24/19.
//  Copyright © 2019 None. All rights reserved.
//

import UIKit


extension UITextField {
    
    func checkMaxLength(maxLength: Int) {
        if let count = self.text?.count {
            if count > maxLength {
                self.deleteBackward()
            }
        }
    }
}
