//
//  Array.swift
//  NEO
//
//  Created by Dev on 5/3/19.
//  Copyright © 2019 None. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    func hasDuplicatedElement() -> Bool {
        var addedDict = [Element: Bool]()
        
        let newArray = filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
        
        if newArray.count < self.count {
            return true
        } else {
            return false
        }
        
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
