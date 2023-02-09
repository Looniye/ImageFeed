import Foundation

final class ProfileImageService {
    private let session = URLSession.shared
    private var task: URLSessionTask?
    private var lastToken: String?
    static let shared = ProfileImageService()
    private(set) var avatarURL: String?
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    func fetchProfileImageURL(username: String, token: String?, completion: @escaping (Result<Void, Error>) -> Void){
        assert(Thread.isMainThread)
        if lastToken == token { return }
        task?.cancel()
        lastToken = token
        guard let token = token else {
            return
        }
        let request = self.makeRequest(username: username, token: token)
        let task = self.session.objectTask(for: request) { [weak self]
            (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let sec):
                if let image = sec.profileImage?.image {
                    self.avatarURL = image
                    NotificationCenter.default                                     
                        .post(
                            name: ProfileImageService.didChangeNotification,
                            object: self,
                            userInfo: ["URL": image])
                }
                completion(.success(()))

            case .failure:
                self.lastToken = nil
                return
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeRequest(username: String, token: String) -> URLRequest {
        guard let url = URL(string: defaultBaseUrl.absoluteString + "/users/" + username) else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
