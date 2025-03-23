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
    let routePoints:[LatLng]?
    
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
        case routePoints = "nod"
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

extension WatchEvent{
    func toCLLocationCoordinate2D()->[CLLocationCoordinate2D]{
        var lineCoordinates: [CLLocationCoordinate2D] = [];
        let rPoints = routePoints;
        if (rPoints != nil) {
            for i in 0..<((rPoints?.count)!) {
                let points = rPoints;
                let lat = points![i].latitude;
                let lon = points![i].longitude;
                lineCoordinates
                    .append(
                        CLLocationCoordinate2D(
                            latitude: lat,
                            longitude: lon
                        ));
            }
        }
        return lineCoordinates;
    }
}
