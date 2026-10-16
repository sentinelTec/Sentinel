//
//  ReportDetailsView.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 22/09/26.
//

import SwiftUI

struct ReportDetailsView: View {
    let reporte: Reporte
    
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
                    
                        if !reporte.evidencia.isEmpty {
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
                            }
                        } else if let imagePath = reporte.imageUrl,
                                  let imageURL = URL(
                                      string: imagePath,
                                      relativeTo: APIClient.baseURL
                                  ) {
                            AsyncImage(url: imageURL) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: 300, maxHeight: 300)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                } else if phase.error != nil {
                                    Text("No se pudo cargar la fotografía.")
                                        .foregroundColor(.white)
                                } else {
                                    ProgressView("Cargando fotografía...")
                                        .tint(.white)
                                }
                            }
                        } else {
                            Text("No hay evidencia adjunta a este reporte.")
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.bottom, 30)
                .frame(maxWidth: 350)
            }
        }
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
}
