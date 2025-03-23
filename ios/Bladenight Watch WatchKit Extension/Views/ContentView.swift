//
//  ContentView.swift
//  BladenightWatch WatchKit Extension
//
//  Created by Lars Huth on 04.06.22.
//

import SwiftUI


struct ContentView: View {
    
    @StateObject var viewModel = CommunicationHandler()
    @State var tabSelection = 0
    
    
    
    //let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    
    var body: some View {
        TabView(selection: $tabSelection) {
            EventView(tabSelection: $tabSelection).environmentObject(viewModel)
                .tag(0)
            if(viewModel.phoneReachable){
                EventDetailView(tabSelection: $tabSelection).environmentObject(viewModel)
                    .tag(1)
                if #available(watchOSApplicationExtension 10.0, *) {
                    MapView(tabSelection: $tabSelection).environmentObject(viewModel).tag(2)
                } else {
                    // Fallback on earlier versions
                }
                if (viewModel.isLocationTracking){
                    FriendsView(tabSelection: $tabSelection).environmentObject(viewModel).tag(3)}
            }
            AboutView(tabSelection: $tabSelection).environmentObject(viewModel).tag(5)
            LogView(tabSelection: $tabSelection).environmentObject(viewModel).tag(4)
        }.tabViewStyle(.automatic).indexViewStyle(.page(backgroundDisplayMode: .never))
        /*.onReceive(timer) {
         _ in
         
         }*/
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
