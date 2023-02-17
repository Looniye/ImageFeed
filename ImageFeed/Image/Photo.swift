import Foundation

struct Photo: Codable {
    let id: String
    let width: CGFloat
    let height: CGFloat
    let createdAt: String?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
    
    init(photoResult: PhotoResult) {
        self.id = photoResult.id
        self.width = CGFloat(photoResult.width)
        self.height = CGFloat(photoResult.height)
        self.createdAt = photoResult.createdAt
        self.welcomeDescription = photoResult.welcomeDescription
        self.thumbImageURL = photoResult.urls[Urls.CodingKeys.thumbImageURL.rawValue]!
        self.largeImageURL = photoResult.urls[Urls.CodingKeys.largeImageURL.rawValue]!
        self.isLiked = photoResult.isLiked
    }
}
struct Urls: Decodable {
    let thumbImageURL: String
    let largeImageURL: String
    
    enum CodingKeys: String, CodingKey {
        case thumbImageURL = "thumb"
        case largeImageURL = "full"
    }
}
