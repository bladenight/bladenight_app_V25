//
//  MapView.swift
//  Bladenight Watch WatchKit Extension
//
//  Created by Lars Huth on 21.08.22.
//
/*
//https://github.com/WillieWangWei/SwiftUI-Tutorials/blob/master/WatchLandmarks%20Extension/WatchMapView.swift

import Foundation
import SwiftUI
import MapKit


struct MapView: WKInterfaceObjectRepresentable {
       func makeWKInterfaceObject(context: WKInterfaceObjectRepresentableContext<MapView>) -> WKInterfaceMap {
         return WKInterfaceMap()
     }
    
    func updateWKInterfaceObject(_ map: WKInterfaceMap, context: WKInterfaceObjectRepresentableContext<MapView>) {
            
            let span = MKCoordinateSpan(latitudeDelta: 0.20,
                longitudeDelta: 0.20)
            
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 48.1325, longitude: 11.5438),
                span: span)
            
            map.setRegion(region)
            //map.userTrackingMode = .follow
        }
    @EnvironmentObject var viewModel: CommunicationHandler
    @Binding var tabSelection: Int
    
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: defaultLatitude, longitude: defaultLongitude), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    //let userTrackingMode: MapUserTrackingMode = .follow
    //var route =  MapKit(polyline:viewModel.routePoints?.routePoints)
    
    }
    


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(tabSelection: .constant(5))
    }
}


*/
