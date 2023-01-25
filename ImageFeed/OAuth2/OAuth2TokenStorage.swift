import Foundation
import SwiftKeychainWrapper

private let keyChainWrapper = KeychainWrapper.standard

final class OAuth2TokenStorage {
    private enum Keys: String {
        case bearerToken
    }
    
    var token: String? {
        get {
            return keyChainWrapper.string(forKey: Keys.bearerToken.rawValue)
        }
        set {
            if let token = newValue {
                keyChainWrapper.set(token, forKey: Keys.bearerToken.rawValue)
            }
        }
    }
}
