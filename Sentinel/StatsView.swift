//
//  StatsView.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 21/09/26.
//

import SwiftUI
import Charts

struct StatsView: View {
    let datos = [
        ("Admin", 0.1),
        ("Vehículo", 0.3),
        ("CyS", 0.5),
        ("Est.", 0.1)
    ]
    
    var body: some View {
        ZStack {
            Color.appColor
                .ignoresSafeArea()
            
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
                    
                    Text("6")
                        .foregroundColor(.white)
                }
                
                BarraEstadistica(
                    cantidad: 100,
                    maximo: 100
                )
                .padding(.horizontal)
                
                HStack(spacing: 30) {
                    Text("Circulación y seguridad")
                        .foregroundColor(.white)
                    
                    Text("3")
                        .foregroundColor(.white)
                }
                
                BarraEstadistica(
                    cantidad: 50,
                    maximo: 100
                )
                .padding(.horizontal)
                
                HStack(spacing: 30) {
                    Text("Estacionamiento")
                        .foregroundColor(.white)
                    
                    Text("1")
                        .foregroundColor(.white)
                }
                
                BarraEstadistica(
                    cantidad: 10,
                    maximo: 100
                )
                .padding(.horizontal)
                
                HStack(spacing: 30) {
                    Text("Administrativas")
                        .foregroundColor(.white)
                    
                    Text("1")
                        .foregroundColor(.white)
                }
                
                BarraEstadistica(
                    cantidad: 10,
                    maximo: 100
                )
                .padding(.horizontal)
                
                HStack(spacing: 30) {
                    Text("Estados de vehículo")
                        .foregroundColor(.white)
                    
                    Text("1")
                        .foregroundColor(.white)
                }
                
                BarraEstadistica(
                    cantidad: 10,
                    maximo: 100
                )
                .padding(.horizontal)
                
                Text("Esta pantalla muestra la cantidad de reportes que se han levantado en un lapso de una semana por categoría")
                    .foregroundColor(.white)
                    .frame(maxWidth: 375)
                    .multilineTextAlignment(.center)
                
                Chart(datos, id: \.0) { dato in
                    SectorMark(
                        angle: .value("Cantidad", dato.1),
                        angularInset: 1
                    )
                }
                .frame(height: 120)
                .padding()
                .foregroundStyle(.yellow)
            }
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

