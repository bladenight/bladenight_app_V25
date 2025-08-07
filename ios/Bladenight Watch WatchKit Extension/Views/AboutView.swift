//
//  AboutView.swift
//  Bladenight Watch WatchKit Extension
//
//  Created by Lars Huth on 04.08.23.
//

import SwiftUI

extension Bundle {
     
    public var appName: String           { getInfo("CFBundleName") }
    public var displayName: String       { getInfo("CFBundleDisplayName") }
    public var language: String          { getInfo("CFBundleDevelopmentRegion") }
    public var identifier: String        { getInfo("CFBundleIdentifier") }
    public var copyright: String         { getInfo("NSHumanReadableCopyright").replacingOccurrences(of: "\\\\n", with: "\n") }
    
    public var appBuild: String          { getInfo("CFBundleVersion") }
    public var appVersionLong: String    { getInfo("CFBundleShortVersionString") }
    //public var appVersionShort: String { getInfo("CFBundleShortVersion") }
    
    fileprivate func getInfo(_ str: String) -> String { infoDictionary?[str] as? String ?? "⚠️" }
}

struct AboutView: View {
    @EnvironmentObject var viewModel: CommunicationHandler
  
    @Binding var tabSelection: Int
    var body: some View {
        ScrollView{
            VStack{
                Text("App Info")
                Text(" \(Bundle.main.displayName)")
                Text("Version \(Bundle.main.appVersionLong) (\(Bundle.main.appBuild))")
                Divider()
                    .frame(height: 2)
                    .overlay(.yellow)
                Text("Eventdaten vom \(viewModel.updateEventDataLastUpdate)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 10));
                Text("Event-Detaildaten vom \(viewModel.realTimeDataLastUpdate)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 10));
                Text("Freundedaten vom \(viewModel.friendDataLastUpdate)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 10))
            }
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView(tabSelection: .constant(4))
    }
}
