//
//  Date.swift
//  ApolloTextInputField
//
//  Created by Pandey, Laxman prasad on 05/07/19.
//  Copyright © 2019 Conduent. All rights reserved.
//

import Foundation

public extension Date {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        return formatter
    }()
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
    func isGreaterThanDate(dateToCompare: Date) -> Bool {
        return self.compare(dateToCompare) == ComparisonResult.orderedDescending
    }
    
    func isLessThanDate(dateToCompare: Date) -> Bool {
        return self.compare(dateToCompare) == ComparisonResult.orderedAscending
    }
    
   func equalToDate(dateToCompare: Date) -> Bool {
        return self.compare(dateToCompare) == ComparisonResult.orderedSame
    }
    func addDays(daysToAdd: Int) -> Date {
        let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: Date = self.addingTimeInterval(secondsInDays)
        return dateWithDaysAdded
    }
    
    func addHours(hoursToAdd: Int) -> Date {
        let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: Date = self.addingTimeInterval(secondsInHours)
        return dateWithHoursAdded
    }
    
    func isValidDateRange(startDate:String, endDate:String)->Bool{
        let rangeStart = startDate.toDate
        let rangeEnd = endDate.toDate
        
        let range = rangeStart...rangeEnd
        if range.contains(self) {
            return true
        }
        return false
    }
}

