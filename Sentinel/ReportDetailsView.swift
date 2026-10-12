//
//  ReportDetailsView.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 22/09/26.
//

import SwiftUI

struct ReportDetailsView: View {
    @Environment(SessionStore.self) private var session
    let reporte: Reporte
    @State private var imagenesRemotas: [URL] = []
    @State private var cargandoEvidencia = false
    
    var body: some View {
        ZStack {
            Color.appColor
                .ignoresSafeArea()
            
            ScrollView(.vertical) {
                VStack(spacing: 10) {
                    Text("Detalle del reporte")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding()
                    
                    VStack(spacing: 5) {
                        Text(reporte.titulo)
                            .font(.title)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                    }
                    
                    HStack(spacing: 20) {
                        Text("Estado de validación")
                            .font(.title3)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                        Text(textoEstado)
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(colorEstado)
                            .clipShape(Capsule())
                    }
                    
                    Text(reporte.tipoCaso.texto)
                        .foregroundColor(.white)
                        .italic()

                    VStack(spacing: 10) {
                        Text("URL de reporte")
                            .font(.title3)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                        Text(reporte.url)
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: 350, maxHeight: 30)
                            .background(Color.white)
                            .clipShape(Capsule())
                    }
                    
                    VStack(spacing: 10) {
                        Text("Descripción breve")
                            .font(.title3)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                        Text(reporte.descripcion)
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: 350, maxHeight: 150)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    
                    VStack(spacing: 10) {
                        Text("Categoría")
                            .font(.title3)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                        Text(reporte.categoria)
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: 350, maxHeight: 30)
                            .background(Color.white)
                            .clipShape(Capsule())
                    }
                    
                    VStack(spacing: 10) {
                        Text("Evidencia")
                            .font(.title3)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    
                        if cargandoEvidencia {
                            ProgressView()
                                .tint(.white)
                        } else if !imagenesRemotas.isEmpty {
                            ScrollView(.horizontal) {
                                HStack(spacing: 15) {
                                    ForEach(imagenesRemotas, id: \.self) { url in
                                        AsyncImage(url: url) { imagen in
                                            imagen
                                                .resizable()
                                                .scaledToFill()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 180, height: 180)
                                        .background(Color.white.opacity(0.2))
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                    }
                                }
                                .padding(.horizontal)
                            }
                        } else if reporte.evidencia.isEmpty {
                            Text("No hay evidencia adjunta a este reporte")
                                .foregroundColor(.white)
                        } else {
                            ScrollView(.horizontal) {
                                HStack(spacing: 15) {
                                    ForEach(reporte.evidencia.indices, id: \.self) {
                                        index in
                                        if let image = UIImage(data: reporte.evidencia[index]) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 180, height: 180)
                                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.bottom, 30)
                .frame(maxWidth: 350)
            }
        }
        .task {
            await cargarEvidencia()
        }
    }

    private func cargarEvidencia() async {
        guard session.isLoggedIn, let idServidor = reporte.idServidor else {
            return
        }
        cargandoEvidencia = true
        if let evidencias = try? await SentinelAPI.evidence(reportId: idServidor) {
            imagenesRemotas = evidencias
                .filter { $0.type == "image" }
                .compactMap { $0.url }
                .compactMap { APIConfig.url($0) }
        }
        cargandoEvidencia = false
    }
    
    private var textoEstado: String {
        switch reporte.estadoValidacion {
        case .enRevision:
            return "En revisión"
            
        case .fraude:
            return "Fraude"
            
        case .confiable:
            return "Confiable"
        }
    }
    
    private var colorEstado: Color {
        switch reporte.estadoValidacion {
        case .enRevision:
            return Color.yellow
            
        case .fraude:
            return Color.red
            
        case .confiable:
            return Color.green
        }
    }
}

#Preview {
    ReportDetailsView(
            reporte: Reporte(
                titulo: "Infracción por exceso de velocidad",
                url: "www.finammx.vip",
                descripcion: "Descripción de prueba para visualizar el detalle del reporte.",
                categoria: "Circulación y seguridad",
                estadoValidacion: .fraude
            )
    )
    .environment(SessionStore())
}
