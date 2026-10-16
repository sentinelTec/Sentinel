//
//  SessionManager.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 10/10/26.
//

import Foundation
import Combine

private enum TokenStorage {
    private static let accessKey = "sentinel.accessToken"
    private static let refreshKey = "sentinel.refreshToken"

    static var accessToken: String? {
        UserDefaults.standard.string(forKey: accessKey)
    }

    static var refreshToken: String? {
        UserDefaults.standard.string(forKey: refreshKey)
    }

    static func save(access: String, refresh: String) {
        UserDefaults.standard.set(access, forKey: accessKey)
        UserDefaults.standard.set(refresh, forKey: refreshKey)
    }

    static func saveAccess(_ token: String) {
        UserDefaults.standard.set(token, forKey: accessKey)
    }

    static func clear() {
        UserDefaults.standard.removeObject(forKey: accessKey)
        UserDefaults.standard.removeObject(forKey: refreshKey)
    }
}

@MainActor
final class SessionManager: ObservableObject {
    @Published private(set) var isAuthenticated: Bool
    @Published private(set) var currentUser: UserProfileDTO?
    @Published var warningMessage: String?

    private var accessToken: String?
    private var refreshToken: String?

    init() {
        accessToken = TokenStorage.accessToken
        refreshToken = TokenStorage.refreshToken
        isAuthenticated = TokenStorage.accessToken != nil
    }

    func register(
        name: String,
        email: String,
        password: String
    ) async throws -> RegisterResponse {

        let body = try JSONEncoder().encode(
            RegisterRequest(
                email: email,
                password: password,
                name: name
            )
        )

        let response: RegisterResponse = try await APIClient.shared.request(
            "auth/register",
            method: "POST",
            body: body
        )

        return response
    }

    func login(email: String, password: String) async throws {
        let body = try JSONEncoder().encode(
            LoginRequest(email: email, password: password)
        )

        let response: LoginResponse = try await APIClient.shared.request(
            "auth/login",
            method: "POST",
            body: body
        )

        accessToken = response.accessToken
        refreshToken = response.refreshToken

        TokenStorage.save(
            access: response.accessToken,
            refresh: response.refreshToken
        )

        isAuthenticated = true

        do {
            currentUser = try await authorizedRequest(
                "auth/me"
            )
        } catch {
            currentUser = nil
        }
    }

    func restoreSession() async {
        guard accessToken != nil else {
            isAuthenticated = false
            return
        }

        do {
            currentUser = try await authorizedRequest("auth/me")
            isAuthenticated = true
        } catch {
            logout()
        }
    }

    func logout() {
        accessToken = nil
        refreshToken = nil
        currentUser = nil
        isAuthenticated = false
        TokenStorage.clear()
    }

    private func authorizedRequest<T: Decodable>(
        _ path: String,
        method: String = "GET",
        body: Data? = nil
    ) async throws -> T {

        guard let token = accessToken else {
            throw APIError.httpStatus(
                401,
                "Debes iniciar sesión."
            )
        }

        do {
            return try await APIClient.shared.request(
                path,
                method: method,
                body: body,
                token: token
            )
        } catch APIError.httpStatus(let code, _) where code == 401 {
            try await refreshAccessToken()

            guard let newToken = accessToken else {
                throw APIError.httpStatus(
                    401,
                    "La sesión ha expirado."
                )
            }

            return try await APIClient.shared.request(
                path,
                method: method,
                body: body,
                token: newToken
            )
        }
    }

    private func refreshAccessToken() async throws {
        guard let refreshToken else {
            logout()
            throw APIError.httpStatus(
                401,
                "No existe un token de renovación."
            )
        }

        let body = try JSONEncoder().encode(
            RefreshRequest(refreshToken: refreshToken)
        )

        do {
            let response: RefreshResponse =
                try await APIClient.shared.request(
                    "auth/refresh",
                    method: "POST",
                    body: body
                )

            accessToken = response.accessToken
            TokenStorage.saveAccess(response.accessToken)
        } catch {
            logout()
            throw error
        }
    }
    
    func fetchReports() async throws -> [Reporte] {
        let responses: [ReportDTO] =
            try await APIClient.shared.request("public/reports")

        return responses.map { mapReport($0) }
    }

    func fetchMyReports() async throws -> [Reporte] {
        let responses: [ReportDTO] =
            try await authorizedRequest("reports/mis-reportes")

        return responses.map { mapReport($0) }
    }

    func createReport(_ reporte: Reporte) async throws -> Reporte {
        guard let categoryId = reporte.categoryIdBackend else {
            throw APIError.httpStatus(
                400,
                "Selecciona una categoría válida."
            )
        }

        let requestBody = CrearReporteRequest(
            categoryId: categoryId,
            caseType: "report",
            title: reporte.titulo.trimmingCharacters(in: .whitespacesAndNewlines),
            description: reporte.descripcionParaBackend
        )

        let body = try JSONEncoder().encode(requestBody)

        let response: ReportDTO = try await authorizedRequest(
            "reports",
            method: "POST",
            body: body
        )

        var reporteGuardado = mapReport(response)
        reporteGuardado.evidencia = reporte.evidencia

        var fallidas = 0

        for imagen in reporte.evidencia {
            do {
                let upload: UploadImageResponse =
                    try await authorizedUploadImage(
                        reportID: response.id,
                        imageData: imagen
                    )

                if reporteGuardado.imageUrl == nil {
                    reporteGuardado.imageUrl = upload.url
                }
            } catch {
                fallidas += 1
            }
        }

        if fallidas > 0 {
            warningMessage =
                "El reporte se creó correctamente, pero no se pudieron subir \(fallidas) de \(reporte.evidencia.count) fotografías."
        }

        return reporteGuardado
    }

    private func authorizedUploadImage(
        reportID: Int,
        imageData: Data
    ) async throws -> UploadImageResponse {

        guard let token = accessToken else {
            throw APIError.httpStatus(
                401,
                "Debes iniciar sesión."
            )
        }

        do {
            return try await APIClient.shared.uploadImage(
                reportID: reportID,
                imageData: imageData,
                token: token
            )
        } catch APIError.httpStatus(let code, _) where code == 401 {
            try await refreshAccessToken()

            guard let newToken = accessToken else {
                throw APIError.httpStatus(
                    401,
                    "La sesión ha expirado."
                )
            }

            return try await APIClient.shared.uploadImage(
                reportID: reportID,
                imageData: imageData,
                token: newToken
            )
        }
    }

    func fetchSummary() async throws -> StatsSummaryDTO {
        try await APIClient.shared.request("public/stats/summary")
    }

    func fetchCategoryStats() async throws -> [CategoryStatDTO] {
        try await APIClient.shared.request("public/stats/by-category")
    }

    func fetchMonthlyStats() async throws -> [MonthlyStatDTO] {
        try await APIClient.shared.request("public/stats/monthly")
    }

    private func mapReport(_ dto: ReportDTO) -> Reporte {
        let categoryID = dto.categoryId ?? dto.fraudTypeId

        let categoria = dto.categoryName ?? categoryName(for: categoryID) ?? "Categoría desconocida"

        let status = (dto.statusName ?? "").lowercased()

        let estado: EstadoValidacion

        if status.contains("rechaz") || status.contains("confiable") {
            estado = .confiable
        } else if status.contains("aprob") || status.contains("fraude") {
            estado = .fraude
        } else {
            estado = .enRevision
        }

        return Reporte(
            backendID: dto.id,
            titulo: dto.title,
            url: extraerURL(de: dto.description),
            descripcion: extraerDescripcion(de: dto.description),
            categoria: categoria,
            estadoValidacion: estado,
            evidencia: [],
            imageUrl: dto.imageUrl
        )
    }

    private func categoryName(for id: Int?) -> String? {
        switch id {
        case 1:
            return "Circulación y Seguridad"
        case 2:
            return "Estacionamiento"
        case 3:
            return "Administrativa"
        case 4:
            return "Estado del vehículo"
        default:
            return nil
        }
    }
    
    private func extraerURL(de texto: String) -> String {
        let prefijo = "Información proporcionada: "

        guard let primeraLinea = texto.components(
            separatedBy: .newlines
        ).first,
        primeraLinea.hasPrefix(prefijo) else {
            return ""
        }

        return String(primeraLinea.dropFirst(prefijo.count))
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func extraerDescripcion(de texto: String) -> String {
        let separador = "\n\nDescripción:\n"

        guard let rango = texto.range(of: separador) else {
            return texto
        }

        return String(texto[rango.upperBound...])
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

