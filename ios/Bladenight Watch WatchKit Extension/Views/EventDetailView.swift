//
//  EventDetailView.swift
//  Bladenight Watch WatchKit Extension
//
//  Created by Lars Huth on 22.08.22.
//

import SwiftUI

struct EventDetailView: View {
    @EnvironmentObject var viewModel: CommunicationHandler
    @Binding var tabSelection: Int
    
    var body: some View {
        ScrollView{
            if(!viewModel.isLocationTracking){
                VStack{
                    Button(action:{
                        viewModel.sendDataMessage(for: .sendNavToggleToFlutter)
                        viewModel.isLocationTracking=true
                    }, label:{
                        Image(systemName: "play")
                    })
                }
            }else{
                VStack{
                    ProgressView("\(DistanceConverter.ConvertMetersToString(distance:(viewModel.realTimeData.user?.pos))) von  \(DistanceConverter.ConvertMetersToString(distance:(viewModel.realTimeData.runningLength)))",value: viewModel.realTimeData.userProgress()).foregroundColor(Color.green)
                    Label("\(viewModel.userSpeed)", systemImage: "gauge") .frame(maxWidth: .infinity, alignment: .leading).foregroundColor(Color.green)
                    }.padding(3)
            }
                
                
                Text("Zug - Tracker \(viewModel.realTimeData.getTrackers())").bold()
                VStack{
                    Text("Zuglänge  \(DistanceConverter.ConvertMetersToString(distance:(viewModel.realTimeData.distanceOfTrainComplete()))) -  \(DateTimeformatter.formatDuration(d: viewModel.realTimeData.timeOfTrainComplete ()))").frame(maxWidth: .infinity, alignment: .leading)
                    Text("Zugkopf ca.").frame(maxWidth: .infinity, alignment: .leading)
                    HStack{
                        Text("\(DistanceConverter.ConvertMetersToString(distance:((viewModel.realTimeData.distanceOfUserToHead()))))")
                        Text(" | \(DateTimeformatter.formatDuration(d: viewModel.realTimeData.timeUserToHead()))") .frame(maxWidth: .infinity, alignment: .leading)
                        
                }.padding(3)
                    
                    Text("Zugende ca.").frame(maxWidth: .infinity, alignment: .leading)
                    HStack{
                        Text("\(DistanceConverter.ConvertMetersToString(distance:((viewModel.realTimeData.distanceOfUserToTail()))))")
                        Text(" | \(DateTimeformatter.formatDuration(d: viewModel.realTimeData.timeUserToTail()))") .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                }.padding(3)
                
                //Text("Zugposition auf Strecke").bold()
                VStack{
                    Text("Zugkopf gef: \(DistanceConverter.ConvertMetersToString(distance:  viewModel.realTimeData.head?.pos))") .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Zugende gef: \(DistanceConverter.ConvertMetersToString(distance:((viewModel.realTimeData.tail?.pos ))))") .frame(maxWidth: .infinity, alignment: .leading)}
                .padding(3)
            
           
            
        }
    }
}

struct EventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailView(tabSelection: .constant(1))
    }
    var body: some View {
        ScrollView{
            HStack{
                VStack{
                    ProgressView("\(DistanceConverter.ConvertMetersToString(distance: 222)) von  \(DistanceConverter.ConvertMetersToString(distance:(5000)))",value: 0.3).foregroundColor(Color.green)
                    Label("3.5", systemImage: "gauge") .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                if(!false){
                    VStack{
                        Button(action:{
                            //viewModel.sendDataMessage(for: .sendNavToggleToFlutter)
                            //viewModel.isLocationTracking=true
                        }, label:{
                            Image(systemName: "play")
                        })
                    }
                }
                }.padding(3)
                
                
                Text("Zug - Tracker 155").bold()
                VStack{
                    Text("Zuglänge  \(DistanceConverter.ConvertMetersToString(distance:(1200))) -  \(DateTimeformatter.formatDuration(d: 200))").frame(maxWidth: .infinity, alignment: .leading)
                    Text("Zugkopf ca.").frame(maxWidth: .infinity, alignment: .leading)
                    HStack{
                        Text("\(DistanceConverter.ConvertMetersToString(distance:((300))))")
                        Text(" | \(DateTimeformatter.formatDuration(d: 10000))") .frame(maxWidth: .infinity, alignment: .leading)
                        
                }.padding(3)
                    
                    Text("Zugende ca.").frame(maxWidth: .infinity, alignment: .leading)
                    HStack{
                        Text("\(DistanceConverter.ConvertMetersToString(distance:((400))))")
                        Text(" | \(DateTimeformatter.formatDuration(d: 20000))") .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                }.padding(3)
                
                //Text("Zugposition auf Strecke").bold()
                VStack{
                    Text("Zugkopf gef: \(DistanceConverter.ConvertMetersToString(distance: 1100))") .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Zugende gef: \(DistanceConverter.ConvertMetersToString(distance:((1400))))") .frame(maxWidth: .infinity, alignment: .leading)}
                .padding(3)
            
           
            
        }
    }
}
