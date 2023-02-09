import Foundation

final class ProfileService {
    private let session = URLSession.shared
    private var task: URLSessionTask?
    static let shared = ProfileService()
    private(set) var profile: Profile?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void){
        assert(Thread.isMainThread)
        task?.cancel()
        
        let request = self.makeRequest(token: token)
        let task = self.session.objectTask(for: request) { [weak self]
            (result: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let decodedObject):
                    let profile = Profile(decodedData: decodedObject)
                    self.profile = profile
                    completion(.success(profile))
                case .failure(let error):
                    completion(.failure(error))
                    print("error")
                    return
                }
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
