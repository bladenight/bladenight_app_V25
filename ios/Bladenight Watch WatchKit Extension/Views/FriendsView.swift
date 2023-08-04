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
    
    var body: some View {
        VStack{
            if(!viewModel.isLocationTracking){
                Text("Tracking inaktiv").padding()
            }
            Text("Freunde aktiv \(viewModel.friends.count)")
            List(viewModel.friends){friend in FriendRow(friend: friend)}
            Text("Daten am: \(viewModel.friendDataLastUpdate)").frame(maxWidth: .infinity, alignment: .leading)
            .font(.system(size: 9))
        }.onAppear(){ viewModel.sendDataMessage(for: .getFriendsDataFromFlutter)
        } .onTapGesture(count: 1) {
            viewModel.sendDataMessage(for: .getFriendsDataFromFlutter)
        }
    }
}


struct FriendRow: View {
    var friend: Friend
    var body: some View {
        VStack{
            Text("\(friend.name)").bold().frame(maxWidth: .infinity, alignment: .leading)
            VStack{
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
                Text("am: \(friend.getLastUpdateString())").frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 9))
            }
        }
    }
}
struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView(tabSelection: .constant(3))
    }
}
