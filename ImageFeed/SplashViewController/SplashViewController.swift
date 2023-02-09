import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private let storyboardInstance = UIStoryboard(name: "Main", bundle: nil)
    private var alertPresent: AlertPresenterProtocol?
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
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
    
    private func showNextScreen(withID screenID: String) {
        let nextViewController = storyboardInstance.instantiateViewController(withIdentifier: screenID)
        UIApplication.shared.windows.first?.rootViewController = nextViewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    ProfileImageService.shared.fetchProfileImageURL(username: (self.profileService.profile?.username)!, token: token) { _ in }
                    self.switchToTabBarController()
                case .failure:
                    self.showError()
                    UIBlockingProgressHUD.dismiss()
                    self.showNextScreen(withID: "TabBarViewController")
                }
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}
