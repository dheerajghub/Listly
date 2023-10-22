//
//  Date+Extension.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 24/09/23.
//

import Foundation

extension Date {
    
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func dayDifference() -> String {
        let calendar = Calendar.current
        if calendar.isDateInYesterday(self) { return "Yesterday" }
        else if calendar.isDateInToday(self) { return "Today" }
        else if calendar.isDateInTomorrow(self) { return "Tomorrow" }
        else { return toString(format: "dd MMM") + "," }
    }
    
    func dueOnFormat() -> String {
        
        let calendar = Calendar.current
        if calendar.isDateInToday(self) {
            return "Today, " + self.toString(format: "hh:mm a")
        } else if calendar.isDateInTomorrow(self) {
            return "Tomorrow, " + self.toString(format: "hh:mm a")
        } else {
            return self.toString(format: "EEEE, MMM d, yyyy, hh:mm a")
        }
        
    }
}
