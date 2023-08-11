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
    
    @State var  timerOneSec = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack{
            if(!viewModel.isLocationTracking){
                Text("Tracking inaktiv").padding()
            }
            ProgressView(value: (Double(timeElapsed)/Double(refreshTime)))
                .scaleEffect(x: 1, y: 0.25, anchor: .center)
                .tint(.yellow).padding(0)
            Text("Freunde aktiv \(viewModel.friends.count)")
                .frame( alignment: .leading)
                .font(.system(size: 9))
            List(viewModel.friends){
                friend in FriendRow(friend: friend)
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
