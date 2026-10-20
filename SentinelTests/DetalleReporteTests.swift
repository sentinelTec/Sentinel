import XCTest
@testable import Sentinel

@MainActor
final class DetalleReporteTests: XCTestCase {
    override func setUp() async throws {
        ServidorFalso.encender()
        UserDefaults.standard.removeObject(forKey: "sentinel.accessToken")
        UserDefaults.standard.removeObject(forKey: "sentinel.refreshToken")
    }

    override func tearDown() async throws {
        ServidorFalso.apagar()
    }

    private func reportePublico(imageUrl: String) -> String {
        """
        [
          {
            "id": 4,
            "categoryId": 2,
            "statusId": 3,
            "caseType": "report",
            "title": "Depósito por multa falsa solicitado por WhatsApp",
            "description": "Información proporcionada: 5500000201\\n\\nDescripción:\\nUn supuesto agente de tránsito me escribió por WhatsApp.",
            "categoryName": "Estacionamiento",
            "statusName": "rechazado",
            "imageUrl": "\(imageUrl)",
            "createdAt": "2026-08-20T13:05:00.000Z"
          }
        ]
        """
    }

    func testDetalleCargaLaInformacionCompletaDelReporte() async throws {
        ServidorFalso.responder("/public/reports", json: reportePublico(imageUrl: "/evidence/9?exp=100&sig=vieja"))

        let session = SessionManager()
        XCTAssertFalse(session.isAuthenticated)

        let reportes = try await session.fetchReports()
        let reporte = try XCTUnwrap(reportes.first { $0.backendID == 4 })

        XCTAssertEqual(reporte.titulo, "Depósito por multa falsa solicitado por WhatsApp")
        XCTAssertEqual(reporte.url, "5500000201")
        XCTAssertEqual(reporte.descripcion, "Un supuesto agente de tránsito me escribió por WhatsApp.")
        XCTAssertEqual(reporte.categoria, "Estacionamiento")
        XCTAssertEqual(reporte.estadoValidacion, .confiable)
        XCTAssertEqual(reporte.imageUrl, "/evidence/9?exp=100&sig=vieja")

        ServidorFalso.responder("/public/reports", json: reportePublico(imageUrl: "/evidence/9?exp=200&sig=nueva"))

        let fotoVigente = await session.fetchImageURL(for: reporte)

        XCTAssertEqual(fotoVigente, "/evidence/9?exp=200&sig=nueva")
        XCTAssertEqual(
            APIClient.url(for: try XCTUnwrap(fotoVigente))?.absoluteString,
            "http://localhost:3000/evidence/9?exp=200&sig=nueva"
        )
    }

    func testDetalleRechazaDatosInvalidos() async throws {
        ServidorFalso.responder("/public/reports", json: """
        [
          {
            "id": "cuatro",
            "description": "Reporte sin título",
            "statusName": "pendiente"
          }
        ]
        """)

        let session = SessionManager()

        do {
            _ = try await session.fetchReports()
            XCTFail("Un reporte sin título y con id inválido no debe cargarse")
        } catch is DecodingError {
        }

        XCTAssertEqual(ServidorFalso.peticiones.count, 1)
    }
}
