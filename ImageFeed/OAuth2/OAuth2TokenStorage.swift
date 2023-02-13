
import SwiftKeychainWrapper
private let keychainStorage = KeychainWrapper.standard
final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private enum Keys: String {
        case bearerToken
    }
    private init() {}
    
    var token: String? {
        get {
            keychainStorage.string(forKey: Keys.bearerToken.rawValue)
        }
        set {
            if let token = newValue {
                keychainStorage.set(token, forKey: Keys.bearerToken.rawValue)
            } else {
                keychainStorage.removeObject(forKey: Keys.bearerToken.rawValue)
            }
        }
    }
    func removeAllKeys() {
        KeychainWrapper.standard.removeAllKeys()
    }
    func store(token: String) {
        self.token = token
    }
}
