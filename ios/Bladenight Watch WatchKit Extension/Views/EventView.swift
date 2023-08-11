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
        ScrollView{
            if(viewModel.watchReachable){
                
                VStack {
                    if(viewModel.activeEvent.lastUpdate == nil){
                        Text("Warte auf Daten vom iPhone ...").onTapGesture(count: 1) {
                            viewModel.sendDataMessage(for: .getEventDataFromFlutter)
                        }
                        ProgressView().padding()
                        
                    }
                    Text("\(viewModel.activeEvent.title)")
                    Text("\(viewModel.activeEvent.routeName)").bold().frame(maxWidth: .infinity, alignment: .center)
                    Text("\(viewModel.activeEvent.startDate)").multilineTextAlignment(.center).border(.yellow)
                        .lineLimit(3)
                    Text("\(viewModel.activeEvent.status)").bold()
                    
                    
                    if(!viewModel.isLocationTracking){
                        Button(action:{
                            viewModel.sendDataMessage(for: .sendNavToggleToFlutter)
                            tabSelection = 2
                        }, label:{
                            Image(systemName: "play")
                        })
                    }
                    Text("Status vom \(viewModel.activeEvent.lastUpdate ?? "-")")
                        .frame( alignment: .center)
                        .font(.system(size: 8));
                    
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
                    debugPrint("Eventview onAppear main")
                    viewModel.sendDataMessage(for: .getEventDataFromFlutter)
                    viewModel.sendDataMessage(for: .getLocationIsTracking)
                }.onTapGesture(count: 1) {
                    viewModel.sendDataMessage(for: .getEventDataFromFlutter)
                }
                
                
            } else{
                VStack {
                    Text("Bladenight-App auf Telefon nicht geöffnet oder keine Verbindung").multilineTextAlignment(.leading)
                    ProgressView().padding()
                }.onAppear(){
                    debugPrint("Eventview onAppear no data")
                    viewModel.sendDataMessage(for: .getEventDataFromFlutter)
                }
            }
            
        }
    }
}
