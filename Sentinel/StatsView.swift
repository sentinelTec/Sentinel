//
//  StatsView.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 21/09/26.
//

import SwiftUI
import Charts

struct StatsView: View {
    @State private var total = 0
    @State private var porCategoria: [CategoryStats] = []
    @State private var errores: [String] = []

    var body: some View {
        estadisticas
    }

    private var estadisticas: some View {
        ZStack {
            Color.appColor
                .ignoresSafeArea()

            ScrollView(.vertical) {
                VStack(spacing: 20) {
                    Text("Estadísticas")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("Reportes por categoría")
                        .font(.title2)
                        .foregroundColor(.white)

                    HStack(spacing: 30) {
                        Text("Todas")
                            .foregroundColor(.white)

                        Text("\(total)")
                            .foregroundColor(.white)
                    }

                    BarraEstadistica(
                        cantidad: total > 0 ? 100 : 0,
                        maximo: 100
                    )
                    .padding(.horizontal)

                    ForEach(porCategoria) { categoria in
                        HStack(spacing: 30) {
                            Text(categoria.categoryName)
                                .foregroundColor(.white)

                            Text("\(categoria.total)")
                                .foregroundColor(.white)
                        }

                        BarraEstadistica(
                            cantidad: Double(categoria.total),
                            maximo: Double(max(total, 1))
                        )
                        .padding(.horizontal)
                    }

                    if !errores.isEmpty {
                        Errors(errores: errores)
                            .foregroundStyle(Color.white)
                            .multilineTextAlignment(.center)
                    }

                    Text("Esta pantalla muestra la cantidad de reportes que se han levantado por categoría")
                        .foregroundColor(.white)
                        .frame(maxWidth: 375)
                        .multilineTextAlignment(.center)

                    if total > 0 {
                        Chart(porCategoria.filter { $0.total > 0 }) { categoria in
                            SectorMark(
                                angle: .value("Cantidad", categoria.total),
                                angularInset: 1
                            )
                        }
                        .frame(height: 120)
                        .padding()
                        .foregroundStyle(.yellow)
                    }
                }
            }
            .refreshable {
                await cargar()
            }
        }
        .task {
            await cargar()
        }
    }

    private func cargar() async {
        do {
            async let resumen = SentinelAPI.summaryStats()
            async let categorias = SentinelAPI.statsByCategory()
            total = try await resumen.totalReports
            porCategoria = try await categorias
            errores = []
        } catch {
            errores = [error.localizedDescription]
        }
    }
}

struct BarraEstadistica: View {
    let cantidad: Double
    let maximo: Double

    var porcentaje: Double {
        min(max(cantidad / maximo, 0), 1)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {

                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 252/255, green: 225/255, blue: 125/255))

                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 255/255, green: 195/255, blue: 0/255))
                    .frame(
                        width: geometry.size.width * porcentaje
                    )
            }
        }
        .frame(height: 16)
    }
}
    
#Preview {
    StatsView()
}

