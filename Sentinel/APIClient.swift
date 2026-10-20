//
//  APIClient.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 10/10/26.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpStatus(Int, String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "La dirección del servidor no es válida."

        case .invalidResponse:
            return "El servidor devolvió una respuesta no válida."

        case .httpStatus(let code, let message):
            return "Error HTTP \(code): \(message)"
        }
    }
}

final class APIClient {
    static let shared = APIClient()

    static let baseURL = URL(string: "http://localhost:3000/")!

    static func url(for path: String) -> URL? {
        let cleanPath = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        return URL(string: cleanPath, relativeTo: baseURL)?.absoluteURL
    }

    private let decoder = JSONDecoder()

    private init() {}

    func request<T: Decodable>(
        _ path: String,
        method: String = "GET",
        body: Data? = nil,
        token: String? = nil
    ) async throws -> T {

        let cleanPath = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))

        guard let url = URL(
            string: cleanPath,
            relativeTo: Self.baseURL
        )?.absoluteURL else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Accept"
        )

        if body != nil {
            request.setValue(
                "application/json",
                forHTTPHeaderField: "Content-Type"
            )
        }

        if let token {
            request.setValue(
                "Bearer \(token)",
                forHTTPHeaderField: "Authorization"
            )
        }

        let (data, response) = try await URLSession.shared.data(
            for: request
        )

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            let message = String(
                data: data,
                encoding: .utf8
            ) ?? "No se recibió información adicional."

            throw APIError.httpStatus(
                httpResponse.statusCode,
                message
            )
        }

        return try decoder.decode(T.self, from: data)
    }

    func uploadImage(
        reportID: Int,
        imageData: Data,
        token: String
    ) async throws -> UploadImageResponse {

        let boundary = UUID().uuidString
        let path = "reports/\(reportID)/image"

        guard let url = URL(
            string: path,
            relativeTo: Self.baseURL
        )?.absoluteURL else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.setValue(
            "Bearer \(token)",
            forHTTPHeaderField: "Authorization"
        )

        request.setValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type"
        )

        var body = Data()

        body.append(
            Data(
                "--\(boundary)\r\n".utf8
            )
        )

        body.append(
            Data(
                "Content-Disposition: form-data; name=\"image\"; filename=\"evidencia.jpg\"\r\n".utf8
            )
        )

        body.append(
            Data("Content-Type: image/jpeg\r\n\r\n".utf8)
        )

        body.append(imageData)

        body.append(
            Data("\r\n--\(boundary)--\r\n".utf8)
        )

        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(
            for: request
        )

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            let message = String(
                data: data,
                encoding: .utf8
            ) ?? "No se pudo subir la fotografía."

            throw APIError.httpStatus(
                httpResponse.statusCode,
                message
            )
        }

        return try decoder.decode(
            UploadImageResponse.self,
            from: data
        )
    }
}
