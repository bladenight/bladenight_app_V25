//
//  Home.swift
//  Runner
//
//  Created by Lars Huth on 12.10.24.
//
import SwiftUI


struct HomeView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("BladeNight")
        }
        .padding()
    }
}


#Preview {
    HomeView()
}
