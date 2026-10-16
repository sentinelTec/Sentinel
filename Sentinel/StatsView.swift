//
//  StatsView.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 21/09/26.
//

import SwiftUI
import Charts

struct StatsView: View {
    @EnvironmentObject private var session: SessionManager
    @State private var resumen: StatsSummaryDTO?
    @State private var categorias: [CategoryStatDTO] = []
    @State private var meses: [MonthlyStatDTO] = []
    @State private var cargando = false
    @State private var errorMensaje: String?

    private var mesesOrdenados: [MonthlyStatDTO] {
        meses.sorted { $0.month < $1.month }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appColor
                    .ignoresSafeArea()
                
                ScrollView(.vertical) {
                    VStack(spacing: 20) {
                        Text("Estadísticas")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                        
                        if cargando {
                            ProgressView("Cargando estadísticas...")
                                .tint(.white)
                        } else {
                            if let resumen {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Resumen general")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    datoResumen("Total de reportes", valor: resumen.totalReports)
                                    
                                    datoResumen("En revisión", valor: resumen.pendingReports)
                                    
                                    datoResumen("Aprobados", valor: resumen.approvedReports)
                                    
                                    datoResumen("Rechazados", valor: resumen.rejectedReports)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.red)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                            
                            VStack(spacing: 12) {
                                Text("Reportes por mes")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                                
                                if mesesOrdenados.isEmpty {
                                    Text("No hay estadísticas mensuales disponibles.")
                                        .foregroundColor(.white)
                                } else {
                                    Chart(mesesOrdenados) { item in
                                        BarMark(
                                            x: .value("Mes", item.month),
                                            y: .value("Reportes", item.total)
                                        )
                                        .foregroundStyle(Color.red)
                                    }
                                    .frame(height: 230)
                                    .chartYAxis {
                                        AxisMarks(position: .leading)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                            
                            VStack(spacing: 12) {
                                Text("Reportes por categoría")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                                
                                ForEach(categorias) { categoria in
                                    HStack {
                                        Text(categoria.categoryName)
                                            .foregroundColor(.red)
                                            .fontWeight(.bold)
                                        
                                        Spacer()
                                        
                                        Text("\(categoria.total)")
                                            .foregroundColor(.white)
                                            .fontWeight(.bold)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color(red: 194/255, green: 194/255, blue: 194/255))
                                            .clipShape(Capsule())
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                            
                            if let errorMensaje {
                                Text(errorMensaje)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: 350)
                }
            }
            
            .task {
                await cargarEstadisticas()
            }
            
            .onChange(of: session.isAuthenticated) { _, _ in
                Task {
                    await cargarEstadisticas()
                }
            }
        }
    }
    
    private func datoResumen(
        _ titulo: String,
        valor: Int
    ) -> some View {
        HStack {
            Text(titulo)
                .foregroundColor(.white)

            Spacer()

            Text("\(valor)")
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(red: 194/255, green: 194/255, blue: 194/255))
                .clipShape(Capsule())
        }
    }

    @MainActor
    private func cargarEstadisticas() async {
        cargando = true
        errorMensaje = nil
        defer { cargando = false }

        do {
            async let nuevoResumen = session.fetchSummary()
            async let nuevasCategorias = session.fetchCategoryStats()
            async let nuevosMeses = session.fetchMonthlyStats()

            let resultados = try await (
                nuevoResumen,
                nuevasCategorias,
                nuevosMeses
            )

            resumen = resultados.0
            categorias = resultados.1
            meses = resultados.2
        } catch {
            errorMensaje =
                "No se pudieron cargar las estadísticas: \(error.localizedDescription)"
        }
    }
}
    
#Preview {
    StatsView()
        .environmentObject(SessionManager())
}
