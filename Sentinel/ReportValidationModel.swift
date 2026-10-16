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
    var backendID: Int? = nil
    var titulo: String = ""
    var url: String = ""
    var descripcion: String = ""
    var categoria: String = ""
    var estadoValidacion: EstadoValidacion = .enRevision
    var evidencia: [Data] = []
    var imageUrl: String? = nil
}

extension Reporte {
    func validaDatos() -> [String] {
        var errores: [String] = []
        if titulo.esVacio {
            errores.append("Ingrese un título para el reporte.")
        }

        if url.esVacio {
            errores.append("Ingrese una url o número de teléfono como información proporcionada.")
        }

        if descripcion.esVacio {
            errores.append("Ingrese una descripción del caso que quiere reportar.")
        }

        if categoria.esVacio {
            errores.append("Seleccione una categoría.")
        }
        
        if categoryIdBackend == nil {
            errores.append("Seleccione una categoría válida.")
        }

        return errores
    }
    
    var categoryIdBackend: Int? {
        switch categoria
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased() {

        case "circulación y seguridad":
            return 1

        case "estacionamiento":
            return 2

        case "administrativa":
            return 3

        case "estado del vehículo":
            return 4

        default:
            return nil
        }
    }

    var descripcionParaBackend: String {
        let urlLimpia = url.trimmingCharacters(in: .whitespacesAndNewlines)

        let descripcionLimpia = descripcion.trimmingCharacters(in: .whitespacesAndNewlines)

        return """
        Información proporcionada: \(urlLimpia)

        Descripción:
        \(descripcionLimpia)
        """
    }
}
