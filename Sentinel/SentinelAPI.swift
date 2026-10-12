import Foundation

enum SentinelAPI {
    private static var client: APIClient { APIClient.shared }

    static func login(email: String, password: String) async throws {
        let tokens: TokenPair = try await client.request(
            "POST", "auth/login",
            json: Credentials(email: email, password: password),
            authenticated: false
        )
        TokenStore.accessToken = tokens.accessToken
        TokenStore.refreshToken = tokens.refreshToken
    }

    static func register(name: String, email: String, password: String) async throws {
        let _: RegisteredAccount = try await client.request(
            "POST", "auth/register",
            json: NewAccount(name: name, email: email, password: password),
            authenticated: false
        )
    }

    static func profile() async throws -> Profile {
        try await client.request("GET", "auth/me")
    }

    static func categories() async throws -> [Category] {
        try await client.request("GET", "public/categories", authenticated: false)
    }

    static func verifiedReports() async throws -> [ReportDTO] {
        try await client.request("GET", "public/reports", authenticated: false)
    }

    static func myReports() async throws -> [ReportDTO] {
        try await client.request("GET", "reports/mis-reportes")
    }

    static func createReport(_ report: NewReport) async throws -> ReportDTO {
        try await client.request("POST", "reports", json: report)
    }

    static func uploadImage(reportId: Int, jpeg: Data) async throws -> UploadedEvidence {
        try await client.upload(
            "reports/\(reportId)/image",
            field: "image",
            fileName: "evidencia.jpg",
            mimeType: "image/jpeg",
            fileData: jpeg
        )
    }

    static func evidence(reportId: Int) async throws -> [EvidenceDTO] {
        try await client.request("GET", "reports/\(reportId)/evidence")
    }

    static func summaryStats() async throws -> SummaryStats {
        try await client.request("GET", "stats/summary")
    }

    static func statsByCategory() async throws -> [CategoryStats] {
        try await client.request("GET", "stats/by-category")
    }
}
