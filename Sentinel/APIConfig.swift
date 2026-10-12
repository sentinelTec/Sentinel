import Foundation

enum APIConfig {
    static let defaultBaseURL = "http://localhost:3000"

    static var baseURL: URL {
        let value = ProcessInfo.processInfo.environment["SENTINEL_API_URL"] ?? defaultBaseURL
        return URL(string: value) ?? URL(string: defaultBaseURL)!
    }

    static func url(_ path: String) -> URL? {
        var base = baseURL.absoluteString
        while base.hasSuffix("/") {
            base.removeLast()
        }
        let suffix = path.hasPrefix("/") ? path : "/" + path
        return URL(string: base + suffix)
    }
}
