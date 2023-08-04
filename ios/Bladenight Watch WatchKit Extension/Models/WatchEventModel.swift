//
//  EventModel.swift
//  Bladenight Watch WatchKit Extension
//
//  Created by Lars Huth on 04.08.23.
//

import SwiftUI
import Foundation


struct WatchEvent: Codable {
    let title: String
    let startDate: String
    let duration: Int
    let routeName: String
    let status: String
    let routeLength: String
    let startPointLatitude: Double?
    let startPointLongitude: Double?
    let startPoint: String?
    let lastUpdate:String?
    
    enum CodingKeys: String, CodingKey {
        case title = "tit"
        case startDate = "sta"
        case duration = "dur"
        case routeName = "rou"
        case status = "sts"
        case routeLength = "len"
        case startPointLatitude = "sla"
        case startPointLongitude = "slo"
        case startPoint = "stp"
        case lastUpdate = "lastupdate"
    }
}

extension WatchEvent: Identifiable {
    var id: Int { return startDate.hashValue}
}

extension WatchEvent{
    func getRouteName()->String{
        return self.routeName
    }
}

