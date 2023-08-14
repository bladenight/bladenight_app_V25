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
    @State var timeElapsed: Int = 0
    @State var refreshTime:Int = 5
    
    @State var  timerOneSec = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
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
                    ProgressView("\(DistanceConverter.ConvertMetersToString(distance:(viewModel.realTimeData.user?.pos))) von  \(DistanceConverter.ConvertMetersToString(distance:(viewModel.realTimeData.runningLength)))",value: viewModel.realTimeData.userProgress()).foregroundColor(Color.yellow)
                        .tint(.yellow)
                    Label("\(viewModel.userSpeed)", systemImage: "gauge") .frame(maxWidth: .infinity, alignment: .leading).foregroundColor(Color.yellow)
                        .font(.system(size: 12))

                }.padding(3)
            }
            
            VStack{
                HStack{
                    Text("Zug").bold().frame(alignment: .leading)  .font(.system(size: 10))
                    Text("Tracker:\(viewModel.realTimeData.getTrackers())").frame(maxWidth: .infinity,alignment: .trailing)  .font(.system(size: 10))
                }.frame(maxWidth: .infinity, alignment: .trailing)
                
                HStack{
                    Text("Länge").frame(alignment: .leading)
                    Text("\(DistanceConverter.ConvertMetersToString(distance:(viewModel.realTimeData.distanceOfTrainComplete()))) | \(DateTimeformatter.formatDuration(d: viewModel.realTimeData.timeOfTrainComplete ()))").frame(maxWidth: .infinity, alignment: .trailing)
                }.frame(maxWidth: .infinity, alignment: .trailing)
                VStack{
                    HStack{
                        Text("Kopf").frame(alignment: .leading)
                        Text("gef: \(DistanceConverter.ConvertMetersToString(distance:  viewModel.realTimeData.head?.pos))") .frame(maxWidth: .infinity, alignment: .trailing)
                    }.frame(maxWidth: .infinity, alignment: .trailing)
                    Text("entf:\(DistanceConverter.ConvertMetersToString(distance:((viewModel.realTimeData.distanceOfUserToHead())))) | \(DateTimeformatter.formatDuration(d:viewModel.realTimeData.timeUserToHead()))" ).frame(maxWidth: .infinity, alignment: .trailing)
                }.frame(maxWidth: .infinity, alignment: .trailing)
                VStack{
                    HStack{
                        Text("Ende").frame(alignment: .leading)
                        Text("gef: \(DistanceConverter.ConvertMetersToString(distance:((viewModel.realTimeData.tail?.pos ))))") .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    Text("entf:\(DistanceConverter.ConvertMetersToString(distance:((viewModel.realTimeData.distanceOfUserToTail())))) | \(DateTimeformatter.formatDuration(d: viewModel.realTimeData.timeUserToTail()))").frame(maxWidth: .infinity, alignment: .trailing)
                }.frame(maxWidth: .infinity, alignment: .trailing)
                Text("Daten vom \(viewModel.realTimeDataLastUpdate)")
                                    .frame( alignment: .center)
                                    .font(.system(size: 8));
                
            }
         
        }.onAppear(){
            debugPrint("EventDetailview onAppear main")
            viewModel.sendDataMessage(for: .getLocationIsTracking)
        }.onTapGesture(count: 1) {
            viewModel.sendDataMessage(for: .getLocationIsTracking)
        }.onReceive(timerOneSec) { _ in
            timeElapsed = timeElapsed + 1
            if (timeElapsed > refreshTime){
                timeElapsed = 0
                viewModel.sendDataMessage(for: .getLocationIsTracking)
                //request current procession data
                viewModel.sendDataMessage(for: .getRealtimeDataFromFlutter)
            }
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
