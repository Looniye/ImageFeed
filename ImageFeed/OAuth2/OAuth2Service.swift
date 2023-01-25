import Foundation

final class OAuth2Service {
    fileprivate let unsplashAuthorizeTokenURLString = "https://unsplash.com/oauth/token"
    static let shared = OAuth2Service()
    private let session = URLSession.shared
    private var lastCode: String?
    private var task: URLSessionTask?
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue!
        }
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        let request = authTokenRequest(code: code)
        let task = self.session.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else {return}
            switch result {
            case .success(let jsonData):
                OAuth2TokenStorage().token = jsonData.accessToken
                completion(.success(jsonData.accessToken))
                self.task = nil
            case .failure:
                self.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
}

extension OAuth2Service {
    private func authTokenRequest(code: String) -> URLRequest {
        var urlComponents = URLComponents(string: unsplashAuthorizeTokenURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "client_secret", value: SecretKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        guard let url = urlComponents.url else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}
