import Foundation

private enum CodingKeysForProfileResult: String, CodingKey {
    case username = "user_name"
    case firstName = "first_name"
    case lastName = "last_name"
    case bio
}

struct ProfileResult: Codable {
    let userName: String?
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeysForProfileResult.self)
        userName = try container.decodeIfPresent(String.self, forKey: .username)
        firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        bio = try container.decodeIfPresent(String.self, forKey: .bio)
    }
}

struct Profile: Decodable {
    let username: String
    let name: String
    let bio: String
    var login: String {"@\(username)"}
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case name = "name"
        case bio = "bio"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        bio = try container.decodeIfPresent(String.self, forKey: .bio) ?? ""
        username = try container.decode(String.self, forKey: .username)
    }
}
