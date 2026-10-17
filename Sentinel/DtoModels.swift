//
//  DtoModels.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 10/10/26.
//

import Foundation

// MARK: - Registro

struct RegisterRequest: Encodable {
    let email: String
    let password: String
    let name: String
}

struct RegisterResponse: Decodable {
    let id: Int
    let email: String
}

// MARK: - Inicio de sesión

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct LoginResponse: Decodable {
    let accessToken: String
    let refreshToken: String
}

// MARK: - Renovación del token

struct RefreshRequest: Encodable {
    let refreshToken: String
}

struct RefreshResponse: Decodable {
    let accessToken: String
}

// MARK: - Perfil del usuario

struct UserProfileDTO: Decodable {
    let id: Int?
    let email: String?
    let name: String?
}

// MARK: - Crear reporte

struct CrearReporteRequest: Encodable {
    let categoryId: Int
    let caseType: String
    let title: String
    let description: String
}

// MARK: - Respuesta de reportes

struct ReportDTO: Decodable {
    let id: Int
    let userId: Int?
    let categoryId: Int?
    let fraudTypeId: Int?
    let statusId: Int?
    let caseType: String?
    let title: String
    let description: String
    let categoryName: String?
    let statusName: String?
    let imageUrl: String?
    let createdAt: String?
}

// MARK: - Subida de evidencia

struct UploadImageResponse: Decodable {
    let message: String?
    let evidenceId: Int?
    let url: String?
}

struct EvidenceDTO: Decodable {
    let id: Int
    let type: String
    let url: String?
}

// MARK: - Estadísticas generales

struct StatsSummaryDTO: Decodable {
    let totalReports: Int
    let pendingReports: Int
    let approvedReports: Int
    let rejectedReports: Int
}

// MARK: - Estadísticas por categoría

struct CategoryStatDTO: Decodable, Identifiable {
    let categoryId: Int
    let categoryName: String
    let total: Int

    var id: Int { categoryId }
}

// MARK: - Estadísticas mensuales

struct MonthlyStatDTO: Decodable, Identifiable {
    let month: String
    let total: Int

    var id: String { month }
}
