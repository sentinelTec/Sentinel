//
//  MyReportsView.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 13/10/26.
//

import SwiftUI

struct MyReports: View {
    @EnvironmentObject private var session: SessionManager
    @State private var reportes: [Reporte] = []
    @State private var cargando = false
    @State private var errorMensaje: String?

    var body: some View {
        ZStack {
            Color.appColor
                .ignoresSafeArea()

            Group {
                if cargando {
                    ProgressView("Cargando mis reportes...")
                        .tint(.white)
                } else if let errorMensaje {
                    Text(errorMensaje)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                } else if reportes.isEmpty {
                    Text("No tienes reportes registrados")
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    ScrollView(.vertical) {
                        Text("Mis reportes")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                        
                        LazyVStack(spacing: 10) {
                            ForEach(reportes) { reporte in
                                NavigationLink {
                                    ReportDetailsView(reporte: reporte)
                                } label: {
                                    ReportTableViewCell(reporte: reporte)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                        .frame(maxWidth: 360)
                    }
                }
            }
        }
        
        .task {
            await cargarMisReportes()
        }
    }

    @MainActor
    private func cargarMisReportes() async {
        cargando = true
        errorMensaje = nil
        defer { cargando = false }

        do {
            reportes = try await session.fetchMyReports()
        } catch {
            errorMensaje =
                "No se pudieron cargar tus reportes: \(error.localizedDescription)"
        }
    }
}

#Preview {
    NavigationStack {
        MyReports()
    }
    .environmentObject(SessionManager())
}
