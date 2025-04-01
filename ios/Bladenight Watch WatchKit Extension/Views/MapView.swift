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
    
    @State var lineCoordinates = [CLLocationCoordinate2D]()
    
    init (tabSelection: Binding<Int>) {
        _tabSelection = tabSelection;
    
    }
    var body: some View {
    
        let _ = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: viewModel.activeEvent.startPointLatitude ?? defaultLatitude, longitude: viewModel.activeEvent.startPointLongitude ?? defaultLongitude),
            span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
        )
        
        let currentRoutePoints = viewModel.activeEvent.toCLLocationCoordinate2D();
        ZStack(alignment: .topLeading){
            
            
            Map(position: $position){
                MapPolyline(
                    coordinates: currentRoutePoints
                ).stroke(Color(hex: 0xFFD700), lineWidth: 2)
                
                if(!viewModel.runningRoute.isEmpty){
                    let first = viewModel.runningRoute.first!;
                    let last = viewModel.runningRoute.last!;
                }
                MapPolyline(
                    coordinates: viewModel.runningRoute
                ).stroke(Color(hex: 0x0028FF), lineWidth: 3)
                
                if (currentRoutePoints.isEmpty){
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
                }
                else{
                    Annotation(
                        "Start",
                        coordinate: CLLocationCoordinate2D(
                            latitude: currentRoutePoints.first!.latitude,
                            longitude: currentRoutePoints.first!.longitude
                        )
                    ) {
                        Image("start_marker")
                            .resizable()
                            .frame(width: 30, height: 20)
                    }
                }
                if(!viewModel.runningRoute.isEmpty){
                    Annotation(
                        "Zuganfang",
                        coordinate: CLLocationCoordinate2D(
                            latitude: viewModel.runningRoute.first!.latitude,
                            longitude: viewModel.runningRoute.first!.longitude
                        )
                    ) {
                        Image("skatechildmunichgreen")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    Annotation(
                        "Zugende",
                        coordinate: CLLocationCoordinate2D(
                            latitude: viewModel.runningRoute.last!.latitude,
                            longitude: viewModel.runningRoute.last!.longitude
                        )
                    ) {
                        Image("skatechildmunichred")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }
                
                if (
                    viewModel.userlocation != nil && viewModel.userlocation?.locCoordinate.latitude != 0.0
                ){
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
                viewModel.sendDataMessage(for: .getEventDataFromFlutter)
            }
            .mapStyle(.standard(elevation: .realistic))
            .padding(EdgeInsets(top: 1.0, leading: 0.0, bottom: 10.0, trailing: 1.0))
            VStack{
                
                HStack{
                    Text("Zug") .font(.system(size: 12))
                        .fontWeight(.medium)
                        .frame(alignment: .leading)
                    Text("\(DistanceConverter.ConvertMetersToString(distance:(viewModel.realTimeData.distanceOfTrainComplete())))|\(DateTimeformatter.formatDuration(d: viewModel.realTimeData.timeOfTrainComplete ()))").font(.system(size: 14))
                        .fontWeight(.bold).frame(alignment: .leading)
                
                }
                if (viewModel.isLocationTracking &&
                        viewModel.userlocation != nil && viewModel.userlocation?.locCoordinate.latitude != 0.0
                    )
                {
                HStack(alignment: .top) {
                    Text("Ges.")
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                        .frame(alignment: .leading)
                   
                    Text(viewModel.userlocation?.speed ?? "- kmh")
                            .font(.system(size: 14))
                            .fontWeight(.bold).frame(alignment: .leading)
                    }
                }
            }
        }
        
    }
    
    let userTrackingMode: MapUserTrackingMode = .follow
}



struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(watchOSApplicationExtension 10.0, *) {
            let startpoint = CLLocationCoordinate2D(
                latitude: 48.13250913196827,
                longitude: 11.543837661522703
            )
            let position = CLLocationCoordinate2D(
                latitude: 48.13250912196827,
                longitude: 11.543837161522703
            )
            let currentRoutePoints :[CLLocationCoordinate2D] = [CLLocationCoordinate2D(latitude: 48.13250912196827, longitude: 11.543837161522703), CLLocationCoordinate2D(latitude: 48.13250912196827, longitude: 11.543437161522703)];
            
            let runningRoute :[CLLocationCoordinate2D] = [CLLocationCoordinate2D(latitude: 48.23250912196827, longitude: 11.643837161522703), CLLocationCoordinate2D(latitude: 48.13250912196827, longitude: 11.543437161522703)];
            
            let userlocation = CLLocationCoordinate2D(
                latitude: 48.13250914196827,
                longitude: 11.543836661522703
            )
            
            var region = MKCoordinateRegion(
                center: startpoint,
                span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
            )
            ZStack(alignment: .topLeading){
                
                
                Map(){
                    MapPolyline(
                        coordinates: currentRoutePoints
                    ).stroke(Color(hex: 0xFFD700), lineWidth: 2)
                    
                    if(!runningRoute.isEmpty){
                        let first = runningRoute.first!;
                        let last = runningRoute.last!;
                    }
                    MapPolyline(
                        coordinates: runningRoute
                    ).stroke(Color(hex: 0x0028FF), lineWidth: 3)
                    
                    if (currentRoutePoints.isEmpty){
                        Annotation(
                            "Start",
                            coordinate: CLLocationCoordinate2D(
                                latitude: startpoint.latitude,
                                longitude: startpoint.longitude
                            )
                        ) {
                            Image("start_marker")
                                .resizable()
                                .frame(width: 30, height: 20)
                        }
                    }
                    else{
                        Annotation(
                            "Start",
                            coordinate: CLLocationCoordinate2D(
                                latitude: currentRoutePoints.first!.latitude,
                                longitude: currentRoutePoints.first!.longitude
                            )
                        ) {
                            Image("start_marker")
                                .resizable()
                                .frame(width: 30, height: 20)
                        }
                    }
                    if(!runningRoute.isEmpty){
                        Annotation(
                            "Zuganfang",
                            coordinate: CLLocationCoordinate2D(
                                latitude: runningRoute.first!.latitude,
                                longitude: runningRoute.first!.longitude
                            )
                        ) {
                            Image("skatechildmunichgreen")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        Annotation(
                            "Zugende",
                            coordinate: CLLocationCoordinate2D(
                                latitude: runningRoute.last!.latitude,
                                longitude: runningRoute.last!.longitude
                            )
                        ) {
                            Image("skatechildmunichred")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                    }
                    
                    if (userlocation.latitude != 0.0 && userlocation.longitude != 0.0 ){
                        Annotation(
                            "Me",
                            coordinate: CLLocationCoordinate2D(
                                latitude: userlocation.latitude,
                                longitude: userlocation.longitude
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
                VStack{
                    HStack(alignment: .top) {
                        Text("Geschw.")
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                        if (true){
                            Text("12 kmh" )
                                .font(.system(size: 14))
                                .fontWeight(.regular)
                        }
                    }
                    HStack{
                        Text("Zuglänge").frame(alignment: .leading) .font(.system(size: 12))
                            .fontWeight(.medium)
                        Text("12km | 15m 3s") .font(.system(size: 12))
                            .fontWeight(.medium)
                    }
                }}
        } else {
            // Fallback on earlier versions
            Text("Karte nicht unterstützt")
        }
    }
}



