//
//  LogView.swift
//  Bladenight Watch WatchKit Extension
//
//  Created by Lars Huth on 03.09.22.
//

import SwiftUI

struct LogView: View {
    @EnvironmentObject var viewModel: CommunicationHandler
    @Binding var tabSelection: Int
    var body: some View {
        ScrollView{
            //viewmodel for testing outputs wich are not readable via Xcode during Debugging
            Text("\(String(describing:viewModel.message))")}
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView(tabSelection: .constant(4))
    }
}
