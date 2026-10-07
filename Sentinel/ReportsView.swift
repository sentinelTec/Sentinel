//
//  ReportsView.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 21/09/26.
//

import SwiftUI

struct ReportsView: View {
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                Text("Reportes recientes")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Button("", systemImage: "plus.square") {
                    
                }
                .frame(width: 50, height: 50)
                .font(.system(size: 30))
                .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    ReportsView()
}
