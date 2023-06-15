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
        }
    }
}


struct FriendRow: View {
    var friend: Friend
    var body: some View {
        VStack{
            Text("\(friend.name)").bold().frame(maxWidth: .infinity, alignment: .leading)
            Text("Zeit: \(friend.getTimeDistanceString())").frame(maxWidth: .infinity, alignment: .leading)
            Text("GPS Distanz:  \(friend.getGpsDistanceString())").frame(maxWidth: .infinity, alignment: .leading)
            Text("gef. Strecke: \( friend.getDistanceString())").frame(maxWidth: .infinity, alignment: .leading)
        
        }
    }
}
struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView(tabSelection: .constant(3))
    }
}
