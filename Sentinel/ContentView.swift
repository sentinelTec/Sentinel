//
//  ContentView.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 14/09/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("", systemImage: "chart.bar.horizontal.page") {
                ReportsView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 0.0, green: 71/255, blue: 148/255))
            }
            
            Tab("", systemImage: "chart.bar.xaxis") {
                StatsView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(red: 0.0, green: 71/255, blue: 148/255))
            }

            Tab("", systemImage: "person.crop.circle.fill") {
                ProfileView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(red: 0.0, green: 71/255, blue: 148/255))
            }
        }
    }
}

#Preview {
    ContentView()
}
