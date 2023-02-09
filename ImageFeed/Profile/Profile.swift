import Foundation

private enum CodingKeysForProfileResult: String, CodingKey {
    case username = "user_name"
    case firstName = "first_name"
    case lastName = "last_name"
    case bio
}

struct ProfileResult: Codable {
    let username, firstName, lastName, bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}

struct Profile: Decodable {
    let username: String?
    let name: String?
    let bio: String?
    var login: String?
    
    init(decodedData: ProfileResult) {
        self.username = decodedData.username
        self.name = (decodedData.firstName ?? "") + " " + (decodedData.lastName ?? "")
        self.login = "@" + (decodedData.username ?? "")
        self.bio = decodedData.bio
    }
}
