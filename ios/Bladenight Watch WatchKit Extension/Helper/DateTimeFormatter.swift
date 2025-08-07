//
//  DateTimeFormatter.swift
//  Bladenight Watch WatchKit Extension
//
//  Created by Lars Huth on 03.09.22.
//

import Foundation

class DateTimeformatter{
    
    /// Returns a formatted string for the given milliseconds to  DD d:HH h:mm m:ss s 
    /// and ignore if 0.
    static func formatDuration (d:Int) -> String{
        if (d<=0){return "0s"}
        let secondsPerDay = 60*60*24 //86400
        let secondsPerHour = 60*60
        let secondsPerMinute = 60
        var seconds:Int = d/1000 //12061499 //18451550 ca 12min
        let (days, _) = seconds.quotientAndRemainder(dividingBy: secondsPerDay)//seconds per day //Rest:139,
        seconds -= days * secondsPerDay
        let (hours, _) = seconds.quotientAndRemainder(dividingBy: secondsPerHour)//seconds per day //Rest:139,
        seconds -= hours * secondsPerHour
        let (minutes, _) = seconds.quotientAndRemainder(dividingBy: secondsPerMinute)//seconds per day //Rest:139,
        seconds -= minutes * secondsPerMinute;
        
        var tokens = [String]();
        if (days != 0) {
            tokens.append("\(days)d")
        }
        if (!tokens.isEmpty || hours != 0) {
            tokens.append("\(hours)h")
        }
        if (!tokens.isEmpty || minutes != 0) {
            tokens.append("\(minutes)m")
        }
        tokens.append("\(seconds)s")
        return tokens.joined(separator: ":").trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}
