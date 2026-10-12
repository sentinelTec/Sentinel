import Foundation

struct APIError: LocalizedError {
    let status: Int
    let message: String

    var errorDescription: String? { message }
}

private struct ServerErrorBody: Decodable {
    let message: ServerMessage?
}

private enum ServerMessage: Decodable {
    case one(String)
    case many([String])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let text = try? container.decode(String.self) {
            self = .one(text)
        } else {
            self = .many(try container.decode([String].self))
        }
    }

    var text: String {
        switch self {
        case .one(let text):
            return text
        case .many(let texts):
            return texts.joined(separator: "\n")
        }
    }
}

final class APIClient {
    static let shared = APIClient()

    var onSessionExpired: (() -> Void)?

    private let session = URLSession.shared
    private var refreshTask: Task<Bool, Never>?

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let text = try container.decode(String.self)
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = formatter.date(from: text) {
                return date
            }
            formatter.formatOptions = [.withInternetDateTime]
            if let date = formatter.date(from: text) {
                return date
            }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Fecha inválida: \(text)")
        }
        return decoder
    }()

    func request<Response: Decodable>(
        _ method: String,
        _ path: String,
        json: (any Encodable)? = nil,
        authenticated: Bool = true
    ) async throws -> Response {
        var request = try makeRequest(method, path)
        if let json {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(json)
        }
        let data = try await perform(request, authenticated: authenticated)
        return try decode(data)
    }

    func upload<Response: Decodable>(
        _ path: String,
        field: String,
        fileName: String,
        mimeType: String,
        fileData: Data
    ) async throws -> Response {
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = try makeRequest("POST", path)
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append(Data("--\(boundary)\r\n".utf8))
        body.append(Data("Content-Disposition: form-data; name=\"\(field)\"; filename=\"\(fileName)\"\r\n".utf8))
        body.append(Data("Content-Type: \(mimeType)\r\n\r\n".utf8))
        body.append(fileData)
        body.append(Data("\r\n--\(boundary)--\r\n".utf8))
        request.httpBody = body

        let data = try await perform(request, authenticated: true)
        return try decode(data)
    }

    private func makeRequest(_ method: String, _ path: String) throws -> URLRequest {
        guard let url = APIConfig.url(path) else {
            throw APIError(status: 0, message: "La dirección del servidor no es válida")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }

    private func decode<Response: Decodable>(_ data: Data) throws -> Response {
        do {
            return try decoder.decode(Response.self, from: data)
        } catch {
            throw APIError(status: 0, message: "Respuesta inesperada del servidor")
        }
    }

    private func perform(_ request: URLRequest, authenticated: Bool, retry: Bool = true) async throws -> Data {
        var request = request
        if authenticated, let token = TokenStore.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, status) = try await send(request)

        if status == 401, authenticated, retry, await refreshTokens() {
            return try await perform(request, authenticated: true, retry: false)
        }

        guard (200..<300).contains(status) else {
            if status == 401, authenticated {
                TokenStore.clear()
                onSessionExpired?()
            }
            throw APIError(status: status, message: Self.message(from: data, status: status))
        }
        return data
    }

    private func send(_ request: URLRequest) async throws -> (Data, Int) {
        do {
            let (data, response) = try await session.data(for: request)
            return (data, (response as? HTTPURLResponse)?.statusCode ?? 0)
        } catch {
            throw APIError(status: 0, message: "No se pudo conectar con el servidor")
        }
    }

    private func refreshTokens() async -> Bool {
        if let refreshTask {
            return await refreshTask.value
        }
        guard let refreshToken = TokenStore.refreshToken,
              var request = try? makeRequest("POST", "auth/refresh") else {
            return false
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(["refreshToken": refreshToken])

        let task = Task { () -> Bool in
            guard let (data, status) = try? await send(request),
                  status == 200,
                  let tokens = try? decoder.decode(AccessToken.self, from: data) else {
                return false
            }
            TokenStore.accessToken = tokens.accessToken
            return true
        }
        refreshTask = task
        let refreshed = await task.value
        refreshTask = nil
        return refreshed
    }

    private static func message(from data: Data, status: Int) -> String {
        if let body = try? JSONDecoder().decode(ServerErrorBody.self, from: data),
           let message = body.message?.text,
           !message.isEmpty {
            return message
        }
        switch status {
        case 401:
            return "Tu sesión expiró, vuelve a iniciar sesión"
        case 403:
            return "No tienes permiso para esta acción"
        case 404:
            return "No se encontró lo que buscabas"
        case 413:
            return "El archivo es demasiado grande"
        case 429:
            return "Demasiados intentos, espera un minuto"
        default:
            return "Ocurrió un error en el servidor (\(status))"
        }
    }
}
