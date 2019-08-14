//
//  Date.swift
//  NEO
//
//  Created by Dev on 3/25/19.
//  Copyright © 2019 None. All rights reserved.
//

import Foundation


extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
    
    var getDateFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM d"
        return dateFormatter.string(from: self)
    }
    
    var yyyyMMdd: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: self)
    }
    
    var dateFormatVietNam: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE, dd MMM yyyy"
        dateFormatter.locale = Locale.init(identifier: "vi_VN")
        return dateFormatter.string(from: self)
    }
    
    func toString() -> String {
        return toStringByFormat(format: "dd-MM-yyyy")
    }
    
    func toTimeStampString() -> String {
        return toStringByFormat(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
    }
    
    func toStringByFormat(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        let stringDate = dateFormatter.string(from: self) //pass Date here
        return stringDate
    }
    
    func toStringByFormatWithLocalTime(byFormat format: String, amSymbol: String = "", pmSymbol: String = "") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.amSymbol = amSymbol
        dateFormatter.pmSymbol = pmSymbol
        let stringDateTime = dateFormatter.string(from: self)
        return stringDateTime
    }
    
    func convertUTCToLocalTime(fromTimeZone timeZoneAbbreviation: String) -> Date? {
        if let timeZone = TimeZone(abbreviation: timeZoneAbbreviation) {
            let targetOffset = TimeInterval(timeZone.secondsFromGMT(for: self))
            let localOffeset = TimeInterval(TimeZone.autoupdatingCurrent.secondsFromGMT(for: self))
            
            return self.addingTimeInterval(localOffeset - targetOffset)
        }
        
        return nil
    }
    
    func getAge(from date: Date) -> Int? {
        let now = Date()
        let birthday: Date = date
        let calendar: Calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        return ageComponents.year
    }
    
    
    func isEqual(date: Date) -> Bool {
        return self.compareWithDate(date: date) == 0 ? true : false
    }
    
    func compareWithDate(date: Date) -> Int {
        let order = Calendar.current.compare(self, to: date,
                                             toGranularity: .day)
        switch order {
        case .orderedSame:
            return 0
        case .orderedAscending:
            return -1
        case .orderedDescending:
            return 1
        }
    }
    
    func compareWithMonth(date: Date) -> Int {
        let order = Calendar.current.compare(self, to: date,
                                             toGranularity: .month)
        switch order {
        case .orderedSame:
            return 0
        case .orderedAscending:
            return -1
        case .orderedDescending:
            return 1
        }
    }
    
    func isGreaterThanDate(date: Date) -> Bool {
        return compareWithDate(date: date) == 1
    }
    
    func isGreaterThanOrEqual(date: Date) -> Bool {
        return [1,0].contains(compareWithDate(date: date))
    }
    
    func isSmallerThanDate(date: Date) -> Bool {
        return compareWithDate(date: date) == -1
    }
	
	static var yesterday: Date { return Date().dayBefore }
	static var tomorrow:  Date { return Date().dayAfter }
	var dayBefore: Date {
		return Calendar.current.date(byAdding: .day, value: -1, to: night)!
	}
	var dayAfter: Date {
		return Calendar.current.date(byAdding: .day, value: 1, to: night)!
	}
	var night: Date {
		return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
	}
}
