import Foundation

private let userDefaults = UserDefaults.standard

final class OAuth2TokenStorage {
    var token: String? {
        get {
            userDefaults.string(forKey: "userToken")
        }
        set {
            userDefaults.set(newValue, forKey: "userToken")
        }
    }
}
