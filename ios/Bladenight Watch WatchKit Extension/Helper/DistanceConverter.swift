//
//  DistanceConverter.swift
//  Bladenight Watch WatchKit Extension
//
//  Created by Lars Huth on 05.09.22.
//

import Foundation

class DistanceConverter{
    static func ConvertMetersToString(distance:Int?)->String{
        let dist = Double(distance ?? 0)
        if dist >= 10000{
            return String(format: "%.2f km", (dist)/1000)
        }
        else {
            return String(format: "%.0f m",dist)
        }
    }
    static func ConvertMetersToString(distance:Double?)->String{
        let dist = Double(distance ?? 0)
        if dist >= 10000{
            return String(format: "%.2f km", (dist)/1000)
        }
        else {
            return String(format: "%.0f m",dist)
        }
    }
}
