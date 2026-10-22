//
//  CreateReportViewTests.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 21/10/26.
//


import XCTest
@testable import Sentinel

final class CreateReportViewTests: XCTestCase {
    func testReporteConCamposVacios() {
        let reporte = Reporte()
        let errores = reporte.validaDatos()

        XCTAssertEqual(errores.count, 5, "Un reporte vacío debe producir cinco errores de validación.")
        XCTAssertTrue(errores.contains("Ingrese un título para el reporte."))
        XCTAssertTrue(errores.contains("Ingrese una url o número de teléfono como información proporcionada."))
        XCTAssertTrue(errores.contains("Ingrese una descripción del caso que quiere reportar."))
        XCTAssertTrue(errores.contains("Seleccione una categoría."))
        XCTAssertTrue(errores.contains("Seleccione una categoría válida."))
    }

    func testReporteConDatosValidos() {
        let reporte = crearReporteValido()
        let errores = reporte.validaDatos()

        XCTAssertTrue(errores.isEmpty,"Un reporte válido no debe contener errores.")
    }

    private func crearReporteValido() -> Reporte {
        var reporte = Reporte()
        reporte.titulo = "Señal de tránsito dañada"
        reporte.url = "www.transito.com"
        reporte.descripcion = "Una señal de tránsito está dañada y necesita revisión."
        reporte.categoria = "Circulación y seguridad"

        return reporte
    }
}