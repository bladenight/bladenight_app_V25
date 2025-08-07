//
//  NotificationView.swift
//  BladenightWatch WatchKit Extension
//
//  Created by Lars Huth on 04.06.22.
//

import SwiftUI


struct NotificationView: View {
    @ObservedObject var viewModel: CommunicationHandler = CommunicationHandler()
    
    var body: some View {
        Text("\(viewModel.activeEventRouteName)").bold().padding(); Text("\(viewModel.activeEventRouteDate)").bold().padding();
        Text("\(viewModel.activeEventRouteStatusText)").padding();
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(
               )
    }
}
