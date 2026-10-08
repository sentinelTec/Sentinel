//
//  ReportTableViewCell.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 05/10/26.
//

import SwiftUI

struct ReportTableViewCell: View {
    let reporte: Reporte
        
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
                
            Text(reporte.titulo)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.black)
                
            Text(reporte.url)
                .font(.body)
                .foregroundColor(.gray)
                
            HStack(spacing: 15) {
                Text(reporte.categoria)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .clipShape(Capsule())
                    
                Text(textoEstado)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(colorEstado)
                    .clipShape(Capsule())
            }
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 230/255, green: 230/255, blue: 230/255))
        .clipShape(RoundedRectangle(cornerRadius: 25))
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
    ReportTableViewCell()
}
