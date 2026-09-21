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
                
            }

            Tab("", systemImage: "chart.bar.xaxis") {
                
            }

            Tab("", systemImage: "person.crop.circle.fill") {
                
            }
        }
    }
}

#Preview {
    ContentView()
}
