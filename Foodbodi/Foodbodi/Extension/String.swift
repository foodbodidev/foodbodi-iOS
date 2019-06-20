//
//  String.swift
//  NEO
//
//  Created by Phuoc on 3/24/19.
//  Copyright © 2019 None. All rights reserved.
//

import Foundation

extension String {
    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(encodedOffset: index)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
    
    
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidPhoneNumber: Bool {
        return self.count == 12
    }
    
    
    func getMinute() -> Int {
        if let range1 = Range(NSRange.init(location: self.count - 4, length: 2), in: self) {
            return Int(self[range1]) ?? 0
        }
        return 0
    }
    
    func getHour() -> Int {
        if let range = self.range(of: ":") {
            let substring = self[..<range.lowerBound]
            if self.contains("PM") {
                return (Int(substring) ?? 0) + 12
                
            } else {
                return Int(substring) ?? 0
            }
        }
        return 0
    }
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }

    
    
}
