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
     //var _tabSelection: Binding<Int>;
    
    
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: defaultLatitude, longitude: defaultLongitude),
        span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
    )
   

    
    
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    @State var lineCoordinates = [CLLocationCoordinate2D]();
    
    init (tabSelection: Binding<Int>) {
        _tabSelection = tabSelection;
    
    }
    var body: some View {
    
        let _ = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: viewModel.activeEvent.startPointLatitude ?? defaultLatitude, longitude: viewModel.activeEvent.startPointLongitude ?? defaultLongitude),
            span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
        )
        Map(position: $position){
            MapPolyline(
                coordinates: viewModel.activeEvent.toCLLocationCoordinate2D()
            ).stroke(Color(hex: 0xFFD700), lineWidth: 2)
            MapPolyline(
                coordinates: viewModel.runningRoute
            ).stroke(Color(hex: 0xFFD700), lineWidth: 2)
            Annotation(
                "Start",
                coordinate: CLLocationCoordinate2D(
                    latitude: viewModel.startpoint.latitude,
                    longitude: viewModel.startpoint.longitude
                )
            ) {
                Image("start_marker")
                    .resizable()
                    .frame(width: 30, height: 20)
            
                
            }
            if (viewModel.userlocation != nil ){
                Annotation(
                    "Position",
                    coordinate: CLLocationCoordinate2D(
                        latitude: viewModel.userlocation!.locCoordinate.latitude,
                        longitude: viewModel.userlocation!.locCoordinate.longitude
                    )
                ) {
                    Image("skater_icon_256_circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
            
        
        }
        //.navigationTitle("Karte")
        .onAppear(){
            
        }
        .mapStyle(.standard(elevation: .realistic))
        .padding(EdgeInsets(top: 1.0, leading: 1.0, bottom: 10.0, trailing: 1.0))
    
        
        
    }
    
  
    
    
    let userTrackingMode: MapUserTrackingMode = .follow
    //var route = MapKit();
    // MapKit(polyline:viewModel.routePoints?.routePoints)
    
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
                    
                }.mapStyle(.standard(elevation: .realistic)).padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 10.0, trailing: 0.0))
            
        } else {
            // Fallback on earlier versions
            
        }
    }
}



