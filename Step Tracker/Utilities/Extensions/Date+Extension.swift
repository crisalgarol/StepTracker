//
//  Date+Extension.swift
//  Step Tracker
//
//  Created by Cristian Olmedo on 24/02/25.
//

import Foundation

extension Date {
    
    var weekDayInt: Int {
        Calendar.current.component(.weekday, from: self)
    }
    
    var weekdayTitle: String {
        self.formatted(.dateTime.weekday(.wide))
    }
    
}
