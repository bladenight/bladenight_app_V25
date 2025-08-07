//
//  Location.swift
//  Bladenight Watch WatchKit Extension
//
//  Created by Lars Huth on 21.08.22.
//

import Foundation
import MapKit
import SwiftUI

struct Location: Identifiable {
    let id = UUID()
    let locName: String
    let locCoordinate: CLLocationCoordinate2D
    let color: Color?
    let speed: String?
}

struct Locations: Identifiable {
    let id = UUID()
    let locations: [Location]
}
