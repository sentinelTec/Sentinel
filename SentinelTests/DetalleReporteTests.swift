import XCTest
@testable import Sentinel

@MainActor
final class DetalleReporteTests: XCTestCase {
    override func tearDown() {
        ServidorFalso.apagar()
    }

    func testCargaLaInformacionCompletaDelReporte() async throws {
        ServidorFalso.responder(json: """
        [{"id": 4, "title": "Depósito por multa falsa", "description": "Información proporcionada: 5500000201\\n\\nDescripción:\\nMe pidieron depositar por WhatsApp", "categoryName": "Estacionamiento", "statusName": "aprobado"}]
        """)

        let reportes = try await SessionManager().fetchReports()
        let reporte = try XCTUnwrap(reportes.first)

        XCTAssertEqual(reporte.titulo, "Depósito por multa falsa")
        XCTAssertEqual(reporte.url, "5500000201")
        XCTAssertEqual(reporte.descripcion, "Me pidieron depositar por WhatsApp")
        XCTAssertEqual(reporte.categoria, "Estacionamiento")
        XCTAssertEqual(reporte.estadoValidacion, .fraude)
    }

    func testRechazaUnReporteSinTitulo() async {
        ServidorFalso.responder(json: """
        [{"id": 4, "description": "Reporte sin título"}]
        """)

        do {
            _ = try await SessionManager().fetchReports()
            XCTFail("No debe cargar un reporte sin título")
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
    }
}
