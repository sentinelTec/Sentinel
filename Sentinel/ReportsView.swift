//
//  ReportsView.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 21/09/26.
//

import SwiftUI

struct ReportsView: View {
    @State private var textoBusqueda = ""
    @State private var categoriaSeleccionada = "Todos"
    
    @State private var reportes: [Reporte] = [
        Reporte(
            titulo: "Infracción por exceso de velocidad",
            url: "www.finammx.vip",
            descripcion: "Reporte relacionado con una supuesta infracción de tránsito.",
            categoria: "Circulación y Seguridad",
            estadoValidacion: .fraude
        ),
        
        Reporte(
            titulo: "Estacionamiento prohibido",
            url: "www.radar-gob.com/spd",
            descripcion: "Reporte de un vehículo estacionado en una zona no permitida.",
            categoria: "Estacionamiento",
            estadoValidacion: .fraude
        ),
        
        Reporte(
            titulo: "Seguro expirado",
            url: "www.vehiculos.mx",
            descripcion: "Reporte relacionado con la documentación del vehículo.",
            categoria: "Administrativas",
            estadoValidacion: .enRevision
        ),
        
        Reporte(
            titulo: "Tránsitos impagos",
            url: "https://bienk.lol.mx",
            descripcion: "Reporte de falta de pagos de multas de tránsito.",
            categoria: "Circulación y Seguridad",
            estadoValidacion: .confiable
        ),
        
        Reporte(
            titulo: "Irregularidad física",
            url: "www.infraccion-express.com/park",
            descripcion: "Reporte relacionado con irregularidad física del vehículo.",
            categoria: "Estado del vehículo",
            estadoValidacion: .enRevision
        ),
        
        Reporte(
            titulo: "Falta del cinturón de seguridad",
            url: "www.infraccion-express.com",
            descripcion: "Reporte de falta de cinturón de seguridad durante manejo.",
            categoria: "Circulación y Seguridad",
            estadoValidacion: .fraude
        )
    ]
    
    var reportesFiltrados: [Reporte] {
        reportes.filter {
            reporte in
            let coincideTexto = textoBusqueda.isEmpty ||
            reporte.titulo.localizedCaseInsensitiveContains(textoBusqueda) ||
            reporte.url.localizedCaseInsensitiveContains(textoBusqueda)
            
            let coincideCategoria = categoriaSeleccionada == "Todos" ||
            reporte.categoria == categoriaSeleccionada
            
            return coincideTexto && coincideCategoria
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appColor
                    .ignoresSafeArea()
                
                ScrollView(.vertical) {
                    VStack(spacing: 20) {
                        HStack(spacing: 20) {
                            Text("Reportes recientes")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            NavigationLink {
                                CreateReportView { nuevoReporte in
                                    reportes.append(nuevoReporte)
                                }
                            } label: {
                                Label("", systemImage: "plus.square")
                                    .frame(width: 50, height: 50)
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal)
                        
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
                                .background(categoriaSeleccionada == "Todos" ? Color.yellow : Color.white)
                                .cornerRadius(10)
                                .clipShape(Capsule())
                                
                                Button("Circulación y seguridad") {
                                    categoriaSeleccionada = "Circulación y Seguridad"
                                }
                                .foregroundColor(.black)
                                .frame(maxHeight: 30)
                                .scaledToFill()
                                .padding()
                                .background(categoriaSeleccionada == "Circulación y Seguridad" ? Color.yellow : Color.white)
                                .cornerRadius(10)
                                .clipShape(Capsule())
                                
                                Button("Estacionamiento") {
                                    categoriaSeleccionada = "Estacionamiento"
                                }
                                .foregroundColor(.black)
                                .frame(maxHeight: 30)
                                .scaledToFill()
                                .padding()
                                .background(categoriaSeleccionada == "Estacionamiento" ? Color.yellow : Color.white)
                                .cornerRadius(10)
                                .clipShape(Capsule())
                                
                                Button("Administrativas") {
                                    categoriaSeleccionada = "Administrativas"
                                }
                                .foregroundColor(.black)
                                .frame(maxHeight: 30)
                                .scaledToFill()
                                .padding()
                                .background(categoriaSeleccionada == "Administrativas" ? Color.yellow : Color.white)
                                .cornerRadius(10)
                                .clipShape(Capsule())
                                
                                Button("Estado del vehículo") {
                                    categoriaSeleccionada = "Estado del vehículo"
                                }
                                .foregroundColor(.black)
                                .frame(maxHeight: 30)
                                .scaledToFill()
                                .padding()
                                .background(categoriaSeleccionada == "Estado del vehículo" ? Color.yellow : Color.white)
                                .cornerRadius(10)
                                .clipShape(Capsule())
                            }
                            .padding(.horizontal)
                        }
                        
                        LazyVStack(spacing: 10) {
                            ForEach(reportesFiltrados) {
                                reporte in
                                NavigationLink {
                                    ReportDetailsView(reporte: reporte)
                                } label: {
                                    ReportTableViewCell(reporte: reporte)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                        
                        if reportesFiltrados.isEmpty {
                            Text("No se encontraron reportes")
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding()
                        }
                    }
                    .frame(maxWidth: 350)
                }
            }
        }
    }
}

#Preview {
    ReportsView()
}
