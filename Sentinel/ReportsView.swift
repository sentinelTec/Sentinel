//
//  ReportsView.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 21/09/26.
//

import SwiftUI

struct ReportsView: View {
    @State var textoBusqueda = ""
    
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
                    
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Buscar titulo de reporte o url", text: $textoBusqueda)
            }
            .padding()
            .background(Color(red: 237/255, green: 237/255, blue: 237/255))
            .clipShape(Capsule())
            .padding(.horizontal)
        }
        .frame(maxWidth: 350)
    }
}

#Preview {
    ReportsView()
}
