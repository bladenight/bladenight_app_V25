//
//  FriendsView.swift
//  Bladenight Watch WatchKit Extension
//
//  Created by Lars Huth on 31.08.22.
//

import SwiftUI

struct FriendsView: View {
    @EnvironmentObject var viewModel: CommunicationHandler
    
    @Binding var tabSelection: Int
    @State var timeElapsed: Int = 0
    @State var refreshTime:Int = 10
    @State var warnColor:Color?
    @State var outDatedData:Bool = false
    @State var  timerOneSec = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack{
            if(!viewModel.isLocationTracking){
                Text("Tracking inaktiv").padding()
            }
            Text("Freunde aktiv \(viewModel.friends.count)")
                .frame( alignment: .leading)
                .font(.system(size: 9)).foregroundColor(warnColor)
            List(viewModel.friends){
                friend in FriendRow(friend: friend)
            }
            if outDatedData {
                Label("Warte auf Aktualisierung", systemImage: "timer") .frame(maxWidth: .infinity, alignment: .leading).foregroundColor(warnColor)
            }
        }.onAppear(){
            timerOneSec = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            viewModel.sendDataMessage(for: .getFriendsDataFromFlutter)
        }.onReceive(timerOneSec) { _ in
            timeElapsed = timeElapsed + 1
            if (timeElapsed > refreshTime){
                timeElapsed = 0
                viewModel.sendDataMessage(for: .getFriendsDataFromFlutter)
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yy HH:mm:ss"
            guard  let date = dateFormatter.date(from: viewModel.realTimeDataLastUpdate) else {
                return
            }
            let ti = date.timeIntervalSinceNow

            if ti < -60.0 {
                warnColor = Color.yellow
                outDatedData = true
            }
            else{
                warnColor = nil
                outDatedData = false
            }
        }
        .onDisappear() {
                timerOneSec.upstream.connect().cancel()
        }
    }
}


struct FriendRow: View {
    var friend: Friend
    var body: some View {
        VStack{
            Text("\(friend.name)").bold().frame(maxWidth: .infinity, alignment: .leading)
            VStack{
                Text("am: \(friend.getLastUpdateString())").frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 9))
                HStack{
                    Text("Geschw:").frame( alignment: .leading)
                        .font(.system(size: 10))
                    Text("\(friend.getSpeedString())").frame(maxWidth: .infinity, alignment: .trailing)
                    
                }
                HStack{
                    Text("Entfernung:").frame( alignment: .leading)
                        .font(.system(size: 10))
                    Text("\(friend.getTimeDistanceString())").frame(maxWidth: .infinity, alignment: .trailing)
                    
                }
                HStack{
                    Text("Luftlinie:").frame( alignment: .leading)
                        .font(.system(size: 10))
                    Text("\(friend.getGpsDistanceString())").frame(maxWidth: .infinity, alignment: .trailing)
                }
                HStack{
                    Text("gef. im Zug:").frame( alignment: .leading)
                        .font(.system(size: 10))
                    Text("\(friend.getDistanceString())").frame(maxWidth: .infinity, alignment: .trailing)
                }
                
            }
        }

    }
}
struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView(tabSelection: .constant(3))
    }
}
