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


struct MapView: View {
    @EnvironmentObject var viewModel: CommunicationHandler
    @Binding var tabSelection: Int
    @State var region = MKCoordinateRegion(
              center: CLLocationCoordinate2D(latitude: defaultLatitude, longitude: defaultLongitude),
              span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
          )
    
    var body: some View {
        var region = MKCoordinateRegion(
           center: CLLocationCoordinate2D(latitude: viewModel.activeEvent.startPointLatitude ?? defaultLatitude, longitude: viewModel.activeEvent.startPointLongitude ?? defaultLongitude),
                       span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
                   )
        Map(coordinateRegion: $region).navigationTitle("Bladenight")
            .onAppear(){
                
            }
        
    }
        
   
    
    //let userTrackingMode: MapUserTrackingMode = .follow
    //var route =  MapKit(polyline:viewModel.routePoints?.routePoints)
    
    }
    


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(tabSelection: .constant(5))
    }
}



