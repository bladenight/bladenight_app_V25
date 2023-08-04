//
//  FriendModel.swift
//  Bladenight Watch WatchKit Extension
//
//  Created by Lars Huth on 31.08.22.
//

import SwiftUI
import Foundation
import MapKit

struct Friend: Codable {
    let friendid: Int
    let name: String
    let color: String
    let isActive: Bool
    let requestId: Int
    let isOnline: Bool
    let speed: Double
    let longitude: Double?
    let latitude: Double?
    let relativeTime: Int?
    let relativeDistance: Int?
    let absolutePosition: Int?
    let distanceToUser: Int?
    let timeToUser: Int?
    let timestamp: Int64
    let hasServerEntry: Bool
}

extension Friend: Identifiable {
    var id: Int { return friendid}
}

extension Friend{
    func getDistanceString()->String{
        var meters = 0;
        if (relativeDistance != nil) {meters = relativeDistance!};
        var s = "- m";
        if (meters == 0) {
            return s;
        } else if (meters < 1000) {
            s = "\(meters) m";
        } else {
            let km: Double = Double(meters) / 1000.0;
            s = "\(String(format: "%.1f", km)) km";
        }
        return s;
    }
    
    func getGpsDistanceString()->String{
        var meters = 0;
        if (distanceToUser != nil) {meters = distanceToUser!};
        var s = "- m";
        if (meters == 0) {
            return s;
        } else if (meters < 1000) {
            s = "\(meters) m";
        } else {
            let km: Double = Double(meters) / 1000.0;
            s = "\(String(format: "%.1f", km)) km";
        }
        return s;
    }
    
    func getTimeDistanceString()->String{
        
        if (timeToUser==0){
            return "0 s"
        }
        if (timeToUser ?? 0<0){
            return "ca. \(String(format: "%.1f", self.timeToUser!/1000)) s"
        }
        if (timeToUser ?? 0>0){
            return "ca. \(String(format: "%.1f", self.timeToUser!/1000)) s"
        }
        return "- s"
    }
    
    func getLastUpdateString()->String{
        let date = Date(timeIntervalSince1970:  TimeInterval(self.timestamp/1000))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd-MM-yy HH:mm:ss"
        return dateFormatter.string(from: date)
       
    }
    
    /*func getSpeedString()->String{
        Double speed = 0;
        if (realSpeed != nil) {speed = realSpeed!};
        var s = "- km/h";
       
        let spd: Double = Double(speed);
            s = "\(String(format: "%.1f", spd)) km/h";
        return s;
    }*/
}

