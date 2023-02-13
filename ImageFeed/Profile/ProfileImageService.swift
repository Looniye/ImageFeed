import Foundation

final class ProfileImageService {
    private let session = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    static let shared = ProfileImageService()
    private(set) var avatarURL: String?
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void){
        assert(Thread.isMainThread)
        if lastCode == username { return }
                task?.cancel()
                lastCode = username

        let request = self.makeRequest(username: username)
        let task = self.session.objectTask(for: request) { [weak self]
            (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let sec):
                self.avatarURL = sec.profileImage?.image
                guard let avatarURL = self.avatarURL else { return }
                    NotificationCenter.default                                     
                        .post(
                            name: ProfileImageService.didChangeNotification,
                            object: self,
                            userInfo: ["URL": avatarURL])
                
                completion(.success(avatarURL))

            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeRequest(username: String) -> URLRequest {
        guard let url = URL(string: defaultBaseUrl.absoluteString + "/users/" + username) else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(oAuth2TokenStorage.token ?? "")", forHTTPHeaderField: "Authorization")
        return request
    }
}
