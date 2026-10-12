import Foundation
import Observation

@Observable
final class SessionStore {
    var isLoggedIn = TokenStore.refreshToken != nil
    var profile: Profile?

    init() {
        APIClient.shared.onSessionExpired = { [weak self] in
            self?.profile = nil
            self?.isLoggedIn = false
        }
    }

    func login(email: String, password: String) async throws {
        try await SentinelAPI.login(email: email, password: password)
        isLoggedIn = true
        await loadProfile()
    }

    func register(name: String, email: String, password: String) async throws {
        try await SentinelAPI.register(name: name, email: email, password: password)
        try await login(email: email, password: password)
    }

    func loadProfile() async {
        profile = try? await SentinelAPI.profile()
    }

    func logout() {
        TokenStore.clear()
        profile = nil
        isLoggedIn = false
    }
}
