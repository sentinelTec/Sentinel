import Foundation

struct TokenPair: Decodable {
    let accessToken: String
    let refreshToken: String
}

struct AccessToken: Decodable {
    let accessToken: String
}

struct Credentials: Encodable {
    let email: String
    let password: String
}

struct NewAccount: Encodable {
    let name: String
    let email: String
    let password: String
}

struct RegisteredAccount: Decodable {
    let id: Int
    let email: String
}

struct Profile: Decodable {
    let name: String?
    let email: String?
    let phone: String?
}

struct Category: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
}

struct ReportDTO: Decodable {
    let id: Int
    let title: String
    let description: String
    let caseType: String
    let categoryId: Int
    let categoryName: String?
    let statusId: Int
    let statusName: String?
    let evidenceUrl: String?
    let createdAt: Date?
}

struct NewReport: Encodable {
    let categoryId: Int
    let caseType: String
    let title: String
    let description: String
    let evidenceUrl: String?
}

struct EvidenceDTO: Decodable {
    let id: Int
    let type: String
    let url: String?
    let content: String?
}

struct UploadedEvidence: Decodable {
    let evidenceId: Int
    let url: String
}

struct SummaryStats: Decodable {
    let totalReports: Int
    let pendingReports: Int
    let approvedReports: Int
    let rejectedReports: Int
}

struct CategoryStats: Decodable, Identifiable {
    let categoryId: Int
    let categoryName: String
    let total: Int

    var id: Int { categoryId }
}
