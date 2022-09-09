//
//  DateFormatter.swift
//  Playground_CoreMotion
//
//  Created by Martin Burghart on 14.12.21.
//

import Foundation

/* returns a String description of current Date with Milliseconds */
func formattedDateStringNow() -> String {
    let d = Date()
    let df = DateFormatter()
    df.dateFormat = "y-MM-dd H:m:ss.SSSS"

    return df.string(from: d) // -> "2020-12-15 17:51:15.1720"
}

/* returns a String description of a Date passed as argument*/
func formattedDateStringFromDate(date: Date) -> String {
    let df = DateFormatter()
    df.dateFormat = "y-MM-dd H:m:ss.SSSS"

    return df.string(from: date)
}

/* returns a Date from a passed String */
func dateFromFormattedDateString(string: String) -> Date {
    let df = DateFormatter()
    df.dateFormat = "y-MM-dd H:m:ss.SSSS"
    
    return df.date(from: string) ?? Date()
}
