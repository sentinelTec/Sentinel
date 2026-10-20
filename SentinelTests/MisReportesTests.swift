import XCTest
@testable import Sentinel

@MainActor
final class MisReportesTests: XCTestCase {
    private let tokenDePrueba = "token-de-prueba"

    override func setUp() async throws {
        ServidorFalso.encender()
        UserDefaults.standard.set(tokenDePrueba, forKey: "sentinel.accessToken")
        UserDefaults.standard.set("refresh-de-prueba", forKey: "sentinel.refreshToken")
    }

    override func tearDown() async throws {
        ServidorFalso.apagar()
        UserDefaults.standard.removeObject(forKey: "sentinel.accessToken")
        UserDefaults.standard.removeObject(forKey: "sentinel.refreshToken")
    }

    func testMisReportesCargaLosReportesDelUsuario() async throws {
        ServidorFalso.responder("/reports/mis-reportes", json: """
        [
          {
            "id": 2,
            "userId": 3,
            "categoryId": 1,
            "statusId": 1,
            "caseType": "señalamiento",
            "title": "¿Es real este correo de multa de tránsito?",
            "description": "Información proporcionada: https://acortador.example/mUlt4cdmx\\n\\nDescripción:\\nMe llegó un correo con el logo de la Secretaría.",
            "categoryName": "Circulación y Seguridad",
            "statusName": "pendiente",
            "imageUrl": "/evidence/3?exp=1792456255&sig=abc",
            "createdAt": "2026-09-03T21:47:00.000Z"
          },
          {
            "id": 1,
            "userId": 3,
            "categoryId": 3,
            "statusId": 2,
            "caseType": "report",
            "title": "Pagué una fotocívica falsa que llegó por SMS",
            "description": "Recibí un SMS que decía que tenía una fotocívica pendiente.",
            "categoryName": null,
            "statusName": "aprobado",
            "imageUrl": null,
            "createdAt": "2026-08-12T10:14:00.000Z"
          }
        ]
        """)

        let session = SessionManager()
        XCTAssertTrue(session.isAuthenticated)

        let reportes = try await session.fetchMyReports()

        XCTAssertEqual(reportes.count, 2)

        let pendiente = reportes[0]
        XCTAssertEqual(pendiente.backendID, 2)
        XCTAssertEqual(pendiente.titulo, "¿Es real este correo de multa de tránsito?")
        XCTAssertEqual(pendiente.url, "https://acortador.example/mUlt4cdmx")
        XCTAssertEqual(pendiente.descripcion, "Me llegó un correo con el logo de la Secretaría.")
        XCTAssertEqual(pendiente.categoria, "Circulación y Seguridad")
        XCTAssertEqual(pendiente.estadoValidacion, .enRevision)
        XCTAssertEqual(pendiente.imageUrl, "/evidence/3?exp=1792456255&sig=abc")

        let aprobado = reportes[1]
        XCTAssertEqual(aprobado.backendID, 1)
        XCTAssertEqual(aprobado.categoria, "Administrativa")
        XCTAssertEqual(aprobado.estadoValidacion, .fraude)
        XCTAssertEqual(aprobado.url, "")
        XCTAssertNil(aprobado.imageUrl)

        let peticion = try XCTUnwrap(ServidorFalso.peticiones.first)
        XCTAssertEqual(peticion.url?.path, "/reports/mis-reportes")
        XCTAssertEqual(peticion.value(forHTTPHeaderField: "Authorization"), "Bearer \(tokenDePrueba)")
    }

    func testMisReportesConSesionVencidaCierraLaSesion() async throws {
        ServidorFalso.responder("/reports/mis-reportes", estado: 401, json: """
        {"message": "Token inválido o expirado", "statusCode": 401}
        """)
        ServidorFalso.responder("/auth/refresh", estado: 401, json: """
        {"message": "Refresh token inválido", "statusCode": 401}
        """)

        let session = SessionManager()
        XCTAssertTrue(session.isAuthenticated)

        do {
            _ = try await session.fetchMyReports()
            XCTFail("Con la sesión vencida no debe regresar reportes")
        } catch APIError.httpStatus(let codigo, _) {
            XCTAssertEqual(codigo, 401)
        }

        XCTAssertFalse(session.isAuthenticated)
        XCTAssertNil(UserDefaults.standard.string(forKey: "sentinel.accessToken"))
        XCTAssertEqual(
            ServidorFalso.peticiones.map { $0.url?.path },
            ["/reports/mis-reportes", "/auth/refresh"]
        )
    }
}
