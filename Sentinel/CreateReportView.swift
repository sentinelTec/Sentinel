//
//  CreateReportView.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 28/09/26.
//

import SwiftUI

struct CreateReportView: View {
    @State var reporte = Reporte()
    
    var body: some View {
        ZStack {
            Color.appColor
                .ignoresSafeArea()
            
            ScrollView(.vertical) {
                VStack(spacing: 10) {
                    Text("Nuevo reporte")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding()
                    
                    Text("Título del reporte")
                        .font(.title3)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    
                    TextField("", text: $reporte.titulo)
                        .padding()
                        .frame(maxWidth: 350, maxHeight: 30)
                        .background(Color.white)
                        .clipShape(Capsule())
                    
                    Text("Información proporcionada")
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
                    
                    Picker("Categoría", selection: $reporte.categoria) {
                        Text("Administrativa")
                            .tag("Administrativa")
                        
                        Text("Circulación y seguridad")
                            .tag("Circulación y seguridad")
                        
                        Text("Estacionamiento")
                            .tag("Estacionamiento")
                        
                        Text("Estado del vehículo")
                            .tag("Estado del vehículo")
                    }
                    .pickerStyle(.menu)
                    .padding()
                    .frame(maxWidth: 350)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Text("Evidencia")
                        .font(.title3)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    
                    Button("Registrar Fraude") {
                        
                    }
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .padding()
                    .scaledToFit()
                    .background(Color.yellow)
                    .cornerRadius(10)
                    .clipShape(Capsule())
                }
            }
        }
    }
}


#Preview {
    CreateReportView()
}
