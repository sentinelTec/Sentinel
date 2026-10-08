//
//  ReportValidationModel.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 05/10/26.
//

import Foundation

enum EstadoValidacion {
    case enRevision
    case fraude
    case confiable
}

struct Reporte: Identifiable {
    var id = UUID()
    var titulo: String = ""
    var url: String = ""
    var descripcion: String = ""
    var categoria: String = ""
    var estadoValidacion: EstadoValidacion = .enRevision
    var evidencia: [Data] = []
}
