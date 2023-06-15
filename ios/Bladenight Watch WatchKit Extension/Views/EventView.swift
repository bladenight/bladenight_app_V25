//
//  EventView.swift
//  Bladenight Watch WatchKit Extension
//
//  Created by Lars Huth on 21.08.22.
//

import Foundation
import SwiftUI

struct EventView: View {
    @EnvironmentObject var viewModel: CommunicationHandler
    @Binding var tabSelection: Int
    @State private var showingStopAlert = false
    
    var body: some View {
        
        if(viewModel.watchReachable){
            
            VStack {
                if(viewModel.activeEventRouteName.isEmpty){
                    Text("Warte auf Daten vom iPhone ...").onTapGesture(count: 1) {
                        viewModel.sendDataMessage(for: .getEventDataFromFlutter)
                    }
                    ProgressView().padding()
                    
                }
                else{
                    Text("nächste Bladenight")
                    Text("\(viewModel.activeEventRouteName)").bold().frame(maxWidth: .infinity, alignment: .center)
                    ;
                    Text("\(viewModel.activeEventRouteDate)").multilineTextAlignment(.center).border(.yellow)
                    
                    
                    Text("\(viewModel.activeEventRouteStatusText)").bold();
                    
                    if(!viewModel.isLocationTracking){
                        Button(action:{
                            viewModel.sendDataMessage(for: .sendNavToggleToFlutter)
                            tabSelection = 2
                        }, label:{
                            Image(systemName: "play")
                        })
                    }
                }
                if(viewModel.isLocationTracking){
                    Button("Stoppe Tracking") {
                        showingStopAlert = true
                    }
                    .alert("Tracking und Unterstützung der Bladenight-Darstellung beenden?", isPresented: $showingStopAlert) {
                        Button("Ja") {
                            viewModel.sendDataMessage(for: .sendNavToggleToFlutter)
                            tabSelection = 1
                            showingStopAlert = false }
                        Button("Nein") { showingStopAlert = false}
                        
                    }
                }
            }.onAppear(){
                let ui:[String:Any]=["getEventDataFromFlutter":0.0]
                _ = viewModel.transferUserInfo(userInfo:ui)
                viewModel.sendDataMessage(for: .getEventDataFromFlutter)
            }
            
            
        } else{
            VStack {
                Text("Bladenight-App auf Telefon nicht geöffnet oder keine Verbindung zum Telefon").multilineTextAlignment(.leading)
                ProgressView().padding()
            }.onAppear(){
                let _:[String:Any]=["getEventDataFromFlutter":0.0]
                viewModel.sendDataMessage(for: .getEventDataFromFlutter)
            }
        }
    }
}
