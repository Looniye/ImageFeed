import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private var alertPresent: AlertPresenterProtocol?
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oAuth2Service = OAuth2Service()
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var viewImageLogo = UIImageView()
    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "YP Black")
        setViewImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func setViewImage() {
        let imageProfile = UIImage(named: "Logo")
        viewImageLogo = UIImageView(image: imageProfile)
        viewImageLogo.tintColor = .gray
        viewImageLogo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewImageLogo)
        NSLayoutConstraint.activate([
            viewImageLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewImageLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            viewImageLogo.widthAnchor.constraint(equalToConstant: 75),
            viewImageLogo.heightAnchor.constraint(equalToConstant: 78)
        ])
    }
    
    private func checkAuthorization() {
        if let token = oAuth2TokenStorage.token {
            UIBlockingProgressHUD.show()
            fetchProfile(token: token)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController")
                    as? AuthViewController else {return}
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true)        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
   private func showError() {
        let alertError: AlertModel = {
            AlertModel(
                title: "Что-то пошло не так",
                message: "Не удалось войти в систему",
                buttonText: "Ок") {}
        }()
        self.alertPresent?.showError(error: alertError)
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(ShowAuthenticationScreenSegueIdentifier)") }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
            UIBlockingProgressHUD.show()
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oAuth2Service.fetchOAuthToken(code) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let token):
                    self.fetchProfile(token: token)
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    self.showError()
                }
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let username):
                    ProfileImageService.shared.fetchProfileImageURL(username: username, token: token) { _ in }
                    self.switchToTabBarController()
                case .failure:
                    self.showError()
                    break
                }
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}
