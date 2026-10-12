import Foundation
import Security

enum TokenStore {
    private static let service = "Tec.Sentinel.tokens"

    static var accessToken: String? {
        get { read("accessToken") }
        set { write("accessToken", newValue) }
    }

    static var refreshToken: String? {
        get { read("refreshToken") }
        set { write("refreshToken", newValue) }
    }

    static func clear() {
        accessToken = nil
        refreshToken = nil
    }

    private static func baseQuery(_ account: String) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
        ]
    }

    private static func read(_ account: String) -> String? {
        var query = baseQuery(account)
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        var item: CFTypeRef?
        guard SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess,
              let data = item as? Data else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    private static func write(_ account: String, _ value: String?) {
        let query = baseQuery(account)
        SecItemDelete(query as CFDictionary)
        guard let value, let data = value.data(using: .utf8) else {
            return
        }
        var attributes = query
        attributes[kSecValueData as String] = data
        attributes[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        SecItemAdd(attributes as CFDictionary, nil)
    }
}
