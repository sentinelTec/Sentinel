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

    init(statusId: Int) {
        switch statusId {
        case 2:
            self = .fraude
        case 3:
            self = .confiable
        default:
            self = .enRevision
        }
    }
}

enum TipoCaso: String, CaseIterable {
    case reporte = "report"
    case senalamiento = "señalamiento"

    var texto: String {
        switch self {
        case .reporte:
            return "Reporte (ya sufrí el fraude)"
        case .senalamiento:
            return "Señalamiento (¿es fraude?)"
        }
    }
}

struct Reporte: Identifiable {
    var id = UUID()
    var idServidor: Int?
    var titulo: String = ""
    var url: String = ""
    var descripcion: String = ""
    var categoria: String = ""
    var categoriaId: Int?
    var tipoCaso: TipoCaso = .reporte
    var estadoValidacion: EstadoValidacion = .enRevision
    var evidencia: [Data] = []
}

extension Reporte {
    init(dto: ReportDTO) {
        self.init(
            idServidor: dto.id,
            titulo: dto.title,
            url: dto.evidenceUrl ?? "",
            descripcion: dto.description,
            categoria: dto.categoryName ?? "",
            categoriaId: dto.categoryId,
            tipoCaso: TipoCaso(rawValue: dto.caseType) ?? .reporte,
            estadoValidacion: EstadoValidacion(statusId: dto.statusId)
        )
    }
}

extension Reporte {
    func validaDatos() -> [String] {
        var errores: [String] = []
        if titulo.esVacio {
            errores.append("Ingrese un título para el reporte.")
        }

        if url.esVacio {
            errores.append("Ingrese una url como información proporcionada.")
        } else if !url.esUrlValida {
            errores.append("Ingrese una url válida, por ejemplo www.sitio.com.")
        }

        if descripcion.esVacio {
            errores.append("Ingrese una descripción del caso que quiere reportar.")
        }

        if categoriaId == nil {
            errores.append("Seleccione una categoría.")
        }

        return errores
    }
}
