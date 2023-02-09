import Foundation

struct LikePhotoResult: Decodable {
    let photo: PhotoResult
}

struct PhotoResult: Decodable {
    let id: String
    let width: CGFloat
    let height: CGFloat
    let welcomeDescription: String?
    let urls: [String: String]
    let createdAt: String?
    let isLiked: Bool

    enum CodingKeys: String, CodingKey {
        case id, urls, width, height
        case createdAt = "created_at"
        case welcomeDescription = "description"
        case isLiked = "liked_by_user"
    }
}


