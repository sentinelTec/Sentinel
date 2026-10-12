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
    
    @State private var reportes: [Reporte] = []
    @State private var categorias: [Category] = []
    @State private var seccion: Seccion = .verificados
    @State private var cargando = false
    @State private var errores: [String] = []

    enum Seccion: String, CaseIterable {
        case verificados = "Verificados"
        case mios = "Mis reportes"
    }

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
                                CreateReportView { _ in
                                    seccion = .mios
                                    Task { await cargar() }
                                }
                            } label: {
                                Label("", systemImage: "plus.square")
                                    .frame(width: 50, height: 50)
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal)

                        Picker("Sección", selection: $seccion) {
                            ForEach(Seccion.allCases, id: \.self) { opcion in
                                Text(opcion.rawValue).tag(opcion)
                            }
                        }
                        .pickerStyle(.segmented)
                        .background(Color.white.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
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
                                .fontWeight(.bold)
                                .frame(maxHeight: 5)
                                .scaledToFill()
                                .padding()
                                .background(categoriaSeleccionada == "Todos" ? Color.yellow : Color.white)
                                .cornerRadius(10)
                                .clipShape(Capsule())
                                
                                ForEach(categorias) { categoria in
                                    Button(categoria.name) {
                                        categoriaSeleccionada = categoria.name
                                    }
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                    .frame(maxHeight: 5)
                                    .scaledToFill()
                                    .padding()
                                    .background(categoriaSeleccionada == categoria.name ? Color.yellow : Color.white)
                                    .cornerRadius(10)
                                    .clipShape(Capsule())
                                }
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
                        
                        if cargando && reportes.isEmpty {
                            ProgressView()
                                .tint(.white)
                                .padding()
                        } else if !errores.isEmpty {
                            Errors(errores: errores)
                                .foregroundStyle(Color.white)
                                .multilineTextAlignment(.center)
                                .padding()
                        } else if reportesFiltrados.isEmpty {
                            Text("No se encontraron reportes")
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding()
                        }
                    }
                    .frame(maxWidth: 350)
                }
                .refreshable {
                    await cargar()
                }
            }
            .task {
                await cargar()
            }
            .onChange(of: seccion) {
                Task { await cargar() }
            }
        }
    }

    private func cargar() async {
        cargando = true
        do {
            if categorias.isEmpty {
                categorias = try await SentinelAPI.categories()
            }
            let respuesta = seccion == .verificados
                ? try await SentinelAPI.verifiedReports()
                : try await SentinelAPI.myReports()
            reportes = respuesta.map(Reporte.init(dto:))
            errores = []
        } catch {
            errores = [error.localizedDescription]
        }
        cargando = false
    }
}

#Preview {
    ReportsView()
        .environment(SessionStore())
}
