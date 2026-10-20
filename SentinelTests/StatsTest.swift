//
//  StatsTest.swift
//  SentinelTests
//
//  Created by alumno on 19/10/26.
//

import XCTest
import SwiftUI
@testable import Sentinel

final class StatsDTOTests: XCTestCase {

    func testMesesOrdenadosCronologicamente() {
        let mesMarzo = MonthlyStatDTO(month: "2026-03", total: 15)
        let mesEnero = MonthlyStatDTO(month: "2026-01", total: 5)
        let mesFebrero = MonthlyStatDTO(month: "2026-02", total: 10)
        
        let mesesDesordenados = [mesMarzo, mesEnero, mesFebrero]
        
        let mesesOrdenados = mesesDesordenados.sorted { $0.month < $1.month }
        
        XCTAssertEqual(mesesOrdenados.count, 3, "La cantidad total de meses debe mantenerse.")
        XCTAssertEqual(mesesOrdenados[0].month, "2026-01", "El primer elemento debe ser Enero.")
        XCTAssertEqual(mesesOrdenados[1].month, "2026-02", "El segundo elemento debe ser Febrero.")
        XCTAssertEqual(mesesOrdenados[2].month, "2026-03", "El tercer elemento debe ser Marzo.")
    }

    func testMesesOrdenadosArregloVacio() {
        let mesesVacios: [MonthlyStatDTO] = []
        
        let resultadoOrdenado = mesesVacios.sorted { $0.month < $1.month }
        
        XCTAssertTrue(resultadoOrdenado.isEmpty, "El resultado debe ser un arreglo vacío.")
        XCTAssertEqual(resultadoOrdenado.count, 0, "El conteo debe ser 0.")
    }
}

