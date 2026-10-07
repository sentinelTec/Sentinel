//
//  ReportsView.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 21/09/26.
//

import SwiftUI

struct ReportsView: View {
    @State var textoBusqueda = ""
    @State private var categoriaSeleccionada = "Todos"
    
    var body: some View {
        ScrollView(.vertical) {
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
                    TextField("Buscar reporte o url", text: $textoBusqueda)
                }
                .padding()
                .background(Color(red: 237/255, green: 237/255, blue: 237/255))
                .clipShape(Capsule())
                .padding(.horizontal)
                    
                ScrollView(.horizontal) {
                    HStack(spacing: 15) {
                        Button("Todos") {
                            categoriaSeleccionada = "Todos"
                        }
                        .foregroundColor(.black)
                        .frame(maxHeight: 30)
                        .scaledToFill()
                        .padding()
                        .background(categoriaSeleccionada == "Todos"
                                    ? Color.yellow
                                    : Color.white)
                        .cornerRadius(10)
                        .clipShape(Capsule())
                        
                        Button("Circulación y seguridad") {
                            categoriaSeleccionada = "Circulación y Seguridad"
                        }
                        .foregroundColor(.black)
                        .frame(maxHeight: 30)
                        .scaledToFill()
                        .padding()
                        .background(categoriaSeleccionada == "Circulación y Seguridad"
                                    ? Color.yellow
                                    : Color.white)
                        .cornerRadius(10)
                        .clipShape(Capsule())
                        
                        Button("Estacionamiento") {
                            categoriaSeleccionada = "Estacionamiento"
                        }
                        .foregroundColor(.black)
                        .frame(maxHeight: 30)
                        .scaledToFill()
                        .padding()
                        .background(categoriaSeleccionada == "Estacionamiento"
                                    ? Color.yellow
                                    : Color.white)
                        .cornerRadius(10)
                        .clipShape(Capsule())
                            
                        Button("Estado del vehículo") {
                            categoriaSeleccionada = "Estado del vehículo"
                        }
                        .foregroundColor(.black)
                        .frame(maxHeight: 30)
                        .scaledToFill()
                        .padding()
                        .background(categoriaSeleccionada == "Estado del vehículo"
                                    ? Color.yellow
                                    : Color.white)
                        .cornerRadius(10)
                        .clipShape(Capsule())
                    }
                }
                .frame(maxWidth: 350)
            }
        }
    }
}

#Preview {
    ReportsView()
}
