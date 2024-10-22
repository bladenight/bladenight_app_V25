//
//  MapView.swift
//  Bladenight Watch WatchKit Extension
//
//  Created by Lars Huth on 21.08.22.
//

//https://github.com/WillieWangWei/SwiftUI-Tutorials/blob/master/WatchLandmarks%20Extension/WatchMapView.swift

import Foundation
import SwiftUI
import MapKit


@available(watchOSApplicationExtension 10.0, *)
struct MapView: View {
    @EnvironmentObject var viewModel: CommunicationHandler
    @Binding var tabSelection: Int
    
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: defaultLatitude, longitude: defaultLongitude),
        span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
    )
    

    
    
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    
    var body: some View {
        let _ = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: viewModel.activeEvent.startPointLatitude ?? defaultLatitude, longitude: viewModel.activeEvent.startPointLongitude ?? defaultLongitude),
            span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
        )
        Map(position: $position){
            Marker("Start",coordinate: viewModel.startpoint)
        }
        .navigationTitle("BladeNight")
        .onAppear(){}
        .mapStyle(.standard(elevation: .realistic))
        Rectangle()
            .fill(Color.black.opacity(0.1))
            .frame(width: 10, height: 10)
        
        
    }
    
    
    
    //let userTrackingMode: MapUserTrackingMode = .follow
    //var route =  MapKit(polyline:viewModel.routePoints?.routePoints)
    
}



struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(watchOSApplicationExtension 10.0, *) {
            let startPoint = CLLocationCoordinate2D(
                latitude: 48.13250913196827,
                longitude: 11.543837661522703
            )
            
            var region = MKCoordinateRegion(
                center: startPoint,
                span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
            )
            Map{
                Marker("Start",coordinate: startPoint)
            }.navigationTitle("BladeNight")
                .onAppear(){
                    
                }.mapStyle(.standard(elevation: .realistic))
            
        } else {
            // Fallback on earlier versions
            
        }
    }
}



