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
            if(viewModel.watchReachable){
                EventDetailView(tabSelection: $tabSelection).environmentObject(viewModel)
                    .tag(2)
                //MapView(tabSelection: $tabSelection).environmentObject(connectivityModel).tag(3)
                if (viewModel.isLocationTracking){
                    FriendsView(tabSelection: $tabSelection).environmentObject(viewModel).tag(3)}
            }
            //LogView(tabSelection: $tabSelection).environmentObject(viewModel).tag(4)
            //MapView(tabSelection: $tabSelection).environmentObject(viewModel).tag(5)
            
        }.tabViewStyle(.automatic).indexViewStyle(.page(backgroundDisplayMode: .automatic))
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
