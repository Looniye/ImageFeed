import Foundation

final class OAuth2Service {
    fileprivate let unsplashAuthorizeTokenURLString = "https://unsplash.com/oauth/token"
    static let shared = OAuth2Service()
    private let session = URLSession.shared
    private var lastCode: String?
    private var task: URLSessionTask?
    private let token = OAuth2TokenStorage.shared
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastCode != code else { return }
        task?.cancel()
        lastCode = code
        let request = authTokenRequest(code: code)
        let task = self.session.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else {return}
            switch result {
            case .success(let decodedObject):
                completion(.success(decodedObject.accessToken))
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
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
            URLQueryItem(name: "client_id", value: accessKey),
            URLQueryItem(name: "client_secret", value: secretKey),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        guard let url = urlComponents.url else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}
