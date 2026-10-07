//
//  ReportDetailsView.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 22/09/26.
//

import SwiftUI

struct ReportDetailsView: View {
    @State var reporte = Reporte()
    
    var body: some View {
        ZStack {
            Color.appColor
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                Text("Detalle del reporte")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding()
                
                Text("Estado de validación")
                    .font(.title2)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                Text("URL de reporte")
                    .font(.title3)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                TextField("", text: $reporte.url)
                    .padding()
                    .frame(maxWidth: 350, maxHeight: 30)
                    .background(Color.white)
                    .clipShape(Capsule())
                
                Text("Descripción breve")
                    .font(.title3)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                TextField("", text: $reporte.descripcion)
                    .padding()
                    .frame(maxWidth: 350, maxHeight: 150)
                    .background(Color.white)
                
                Text("Categoría")
                    .font(.title3)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                TextField("", text: $reporte.categoria)
                    .padding()
                    .frame(maxWidth: 350, maxHeight: 30)
                    .background(Color.white)
                    .clipShape(Capsule())
                
                Text("Evidencia")
                    .font(.title3)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
            }
        }
    }
}

#Preview {
    ReportDetailsView()
}
