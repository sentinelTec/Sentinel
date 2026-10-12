//
//  SentinelApp.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 14/09/26.
//

import SwiftUI

@main
struct SentinelApp: App {
    @State private var session = SessionStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(session)
        }
    }
}
