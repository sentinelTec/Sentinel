//
//  ReportsView.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 21/09/26.
//

import SwiftUI

struct ReportsView: View {
    @EnvironmentObject private var session: SessionManager
    @State private var textoBusqueda = ""
    @State private var categoriaSeleccionada = "Todos"
    @State private var reportes: [Reporte] = []
    @State private var mostrarLogin = false
    @State private var mostrarCrearReporte = false
    @State private var cargando = false
    @State private var errorMensaje: String?
    @State private var mostrarAviso = false
    
    private let categorias = [
        "Todos",
        "Circulación y Seguridad",
        "Estacionamiento",
        "Administrativa",
        "Estado del vehículo"
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
                            
                            Button {
                                if session.isAuthenticated {
                                    mostrarCrearReporte = true
                                } else {
                                    mostrarLogin = true
                                }
                            } label: {
                                Image(systemName: "plus.square")
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
                                .textInputAutocapitalization(.never)
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
                                .fontWeight(.bold)
                                .frame(maxHeight: 5)
                                .scaledToFill()
                                .padding()
                                .background(categoriaSeleccionada == "Todos" ? Color.yellow : Color.white)
                                .cornerRadius(10)
                                .clipShape(Capsule())
                                
                                Button("Circulación y Seguridad") {
                                    categoriaSeleccionada = "Circulación y Seguridad"
                                }
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .frame(maxHeight: 5)
                                .scaledToFill()
                                .padding()
                                .background(categoriaSeleccionada == "Circulación y Seguridad" ? Color.yellow : Color.white)
                                .cornerRadius(10)
                                .clipShape(Capsule())
                                
                                Button("Estacionamiento") {
                                    categoriaSeleccionada = "Estacionamiento"
                                }
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .frame(maxHeight: 5)
                                .scaledToFill()
                                .padding()
                                .background(categoriaSeleccionada == "Estacionamiento" ? Color.yellow : Color.white)
                                .cornerRadius(10)
                                .clipShape(Capsule())
                                
                                Button("Administrativas") {
                                    categoriaSeleccionada = "Administrativas"
                                }
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .frame(maxHeight: 5)
                                .scaledToFill()
                                .padding()
                                .background(categoriaSeleccionada == "Administrativas" ? Color.yellow : Color.white)
                                .cornerRadius(10)
                                .clipShape(Capsule())
                                
                                Button("Estado del vehículo") {
                                    categoriaSeleccionada = "Estado del vehículo"
                                }
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .frame(maxHeight: 5)
                                .scaledToFill()
                                .padding()
                                .background(categoriaSeleccionada == "Estado del vehículo" ? Color.yellow : Color.white)
                                .cornerRadius(10)
                                .clipShape(Capsule())
                            }
                            .padding(.horizontal)
                        }
                        
                        if cargando {
                            ProgressView("Cargando reportes...")
                                .tint(.white)
                                .foregroundColor(.white)
                                .padding()
                        } else {
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
                            
                            if reportesFiltrados.isEmpty && !cargando && errorMensaje == nil {
                                Text("No se encontraron reportes")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .padding()
                            }
                        }
                        
                        if let errorMensaje {
                            Text(errorMensaje)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.vertical)
                    .frame(maxWidth: 360)
                }
            }
            
            .navigationDestination(isPresented: $mostrarLogin) {
                LoginView {
                    mostrarLogin = false
                    mostrarCrearReporte = true
                }
            }
            
            .navigationDestination(isPresented: $mostrarCrearReporte) {
                CreateReportView { nuevoReporte in
                    let guardado = try await session.createReport(nuevoReporte)
                    reportes.insert(guardado, at: 0)
                }
            }
            
            .task {
                    await cargarReportes()
            }
            
            .refreshable {
                await cargarReportes()
            }
            
            .onChange(of: session.isAuthenticated) { _, _ in
                Task {
                    await cargarReportes()
                }
            }
            
            .alert("Aviso", isPresented: $mostrarAviso) {
                Button("Aceptar", role: .cancel) {}
            } message: {
                Text(session.warningMessage ?? "")
            }
            
            .onChange(of: session.warningMessage) { _, mensaje in
                if mensaje != nil {
                    mostrarAviso = true
                }
            }
        }
    }
    
    @MainActor
    private func cargarReportes() async {
        cargando = true
        errorMensaje = nil
        defer { cargando = false }

        do {
            reportes = try await session.fetchReports()
        } catch {
            errorMensaje =
                "No se pudieron cargar los reportes: \(error.localizedDescription)"
        }
    }
}

#Preview {
    ReportsView()
        .environmentObject(SessionManager())
}
