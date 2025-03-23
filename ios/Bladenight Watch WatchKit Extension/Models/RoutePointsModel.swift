//
//  RoutePoints.swift
//  Bladenight Watch WatchKit Extension
//
//  Created by Lars Huth on 26.08.22.
//

import SwiftUI
import Foundation
import MapKit

struct RoutePoints: Codable {
    let routeName: String
    var routePoints: [Coordinate]
    
    enum CodingKeys: String, CodingKey {
        case routeName = "nam"
        case routePoints = "nod"
    }
}

//source https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types

struct Coordinate {
    var latitude: Double
    var longitude: Double

    enum CodingKeys: String, CodingKey {
        case latitude = "la"
        case longitude = "lo"
   
    }
    
}

extension Coordinate: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try values.decode(Double.self, forKey: .latitude)
        longitude = try values.decode(Double.self, forKey: .longitude)
      
       }
}

extension Coordinate: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        }
}

struct LatLngList: Codable {
    var routePoints: [LatLng]
}

struct LatLng {
    var latitude: Double
    var longitude: Double

    enum CodingKeys: String, CodingKey {
        case latitude = "la"
        case longitude = "lo"
   
    }
    
}

extension LatLng: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try values.decode(Double.self, forKey: .latitude)
        longitude = try values.decode(Double.self, forKey: .longitude)
      
       }
}

extension LatLng: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        }
}

