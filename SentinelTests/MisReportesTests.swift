import XCTest
@testable import Sentinel

@MainActor
final class MisReportesTests: XCTestCase {
    override func setUp() {
        UserDefaults.standard.set("token-de-prueba", forKey: "sentinel.accessToken")
    }

    override func tearDown() {
        ServidorFalso.apagar()
        UserDefaults.standard.removeObject(forKey: "sentinel.accessToken")
    }

    func testCargaLosReportesDelUsuario() async throws {
        ServidorFalso.responder(json: """
        [{"id": 2, "title": "Correo de multa falsa", "description": "Me llegó un correo sospechoso", "statusName": "pendiente"}]
        """)

        let reportes = try await SessionManager().fetchMyReports()

        XCTAssertEqual(reportes.count, 1)
        XCTAssertEqual(reportes[0].titulo, "Correo de multa falsa")
        XCTAssertEqual(reportes[0].estadoValidacion, .enRevision)
    }

    func testErrorDelServidorNoCargaReportes() async {
        ServidorFalso.responder(estado: 500, json: """
        {"message": "Error interno"}
        """)

        do {
            _ = try await SessionManager().fetchMyReports()
            XCTFail("No debe cargar reportes si el servidor falla")
        } catch APIError.httpStatus(let codigo, _) {
            XCTAssertEqual(codigo, 500)
        } catch {
            XCTFail("Error inesperado: \(error)")
        }
    }
}
