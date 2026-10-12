//
//  ContentView.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 14/09/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(SessionStore.self) private var session

    var body: some View {
        if session.isLoggedIn {
            TabView {
                Tab("Reportes", systemImage: "chart.bar.horizontal.page") {
                    ReportsView()
                }

                Tab("Estadísticas", systemImage: "chart.bar.xaxis") {
                    StatsView()
                }

                Tab("Perfil", systemImage: "person.crop.circle.fill") {
                    ProfileView()
                }
            }
            .task {
                await session.loadProfile()
            }
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
        .environment(SessionStore())
}
