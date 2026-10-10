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

extension Reporte {
    func validaDatos() -> [String] {
        var errores: [String] = []
        if titulo.esVacio {
            errores.append("Ingrese un título para el reporte.")
        }

        if url.esVacio {
            errores.append("Ingrese una url como información proporcionada.")
        }

        if descripcion.esVacio {
            errores.append("Ingrese una descripción del caso que quiere reportar.")
        }

        if categoria.esVacio {
            errores.append("Seleccione una categoría.")
        }

        return errores
    }
}
