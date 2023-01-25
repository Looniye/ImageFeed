import Foundation

final class ProfileService {
    private let session = URLSession.shared
    private var task: URLSessionTask?
    private var lastToken: String?
    static let shared = ProfileService()
    fileprivate let profileInfoURLString: String = "https://api.unsplash.com/me"
    private(set) var profile: Profile?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<String, Error>) -> Void){
        assert(Thread.isMainThread)
        if lastToken == token { return }
        task?.cancel()
        lastToken = token
        
        let request = self.makeRequest(token: token)
        let task = self.session.objectTask(for: request) { [weak self]
            (result: Result<Profile, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
                completion(.success(profile.username))
                self.task = nil
            case .failure:
                self.lastToken = nil
                return
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeRequest(token: String) -> URLRequest {
        guard let url = URL(string: defaultBaseUrl.absoluteString + "/me") else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
