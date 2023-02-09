import UIKit
import Kingfisher

final class ProfileViewController: UIViewController{
    private var viewProfileImage = UIImageView()
    private var labelNameProfile = UILabel()
    private var loginNameLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var buttonLogout = UIButton()
    
    private var gradientProfileImage: CAGradientLayer!
    private var gradientNameProfile: CAGradientLayer!
    private var gradientNameLabel: CAGradientLayer!
    private var gradientDescriptionLabel: CAGradientLayer!
    
    let gradient = CAGradientLayer()
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private var profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private let animationGradient = AnimationGradientFactory.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP Black")
        setUI()
        
        guard let profile = profileService.profile else {return}
        updateProfileDetails(profile: profile)
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
        
    }
    
    private func setUI(){
        setViewProfileImage()
        setLabelNameProfile()
        setLoginNameLabel()
        setDescriptionLabel()
        setLogoutButton()
    }
    private func setLabelNameProfile() {
        labelNameProfile.text = "Екатерина Новикова"
        labelNameProfile.textColor = UIColor(named: "YP White")
        labelNameProfile.font = UIFont.systemFont(ofSize: 23)
        labelNameProfile.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelNameProfile)
        NSLayoutConstraint.activate([
            labelNameProfile.topAnchor.constraint(equalTo: viewProfileImage.bottomAnchor, constant: 8),
            labelNameProfile.leadingAnchor.constraint(equalTo: viewProfileImage.leadingAnchor)
        ])
        
        gradientNameProfile = animationGradient.createGradient(width: 223, height: 23, cornerRadius: 11.5)
        self.labelNameProfile.layer.addSublayer(gradientNameProfile)
        
    }
    private func setLoginNameLabel() {
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.textColor = UIColor(named: "YP Gray")
        loginNameLabel.font = UIFont.systemFont(ofSize: 13)
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        NSLayoutConstraint.activate([
            loginNameLabel.topAnchor.constraint(equalTo: labelNameProfile.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        gradientNameLabel = animationGradient.createGradient(width: 89, height: 18, cornerRadius: 9)
        self.loginNameLabel.layer.addSublayer(gradientNameLabel)
    }
    private func setDescriptionLabel(){
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = UIColor(named: "YP White")
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        gradientDescriptionLabel = animationGradient.createGradient(width: 67, height: 18, cornerRadius: 9)
        self.descriptionLabel.layer.addSublayer(gradientDescriptionLabel)
    }
    private func setViewProfileImage() {
        let imageProfile = UIImage(named: "placeholder.fill")
        viewProfileImage = UIImageView(image: imageProfile)
        viewProfileImage.tintColor = .gray
        viewProfileImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewProfileImage)
        NSLayoutConstraint.activate([
            viewProfileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            viewProfileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            viewProfileImage.widthAnchor.constraint(equalToConstant: 70),
            viewProfileImage.heightAnchor.constraint(equalToConstant: 70)
        ])
        gradientProfileImage = animationGradient.createGradient(width: 70, height: 70, cornerRadius: 35)
        self.viewProfileImage.layer.addSublayer(gradientProfileImage)
        
    }
    private func setLogoutButton() {
        let imageButton = UIImage(named: "logout")
        buttonLogout = UIButton.systemButton(with: imageButton!,
                                             target: self,
                                             action: #selector(didTapLogoutButton))
        
        buttonLogout.tintColor = UIColor(named: "YP Red")
        buttonLogout.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonLogout)
        NSLayoutConstraint.activate([
            buttonLogout.centerYAnchor.constraint(equalTo: viewProfileImage.centerYAnchor),
            buttonLogout.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26)
        ])
    }
    private func updateProfileDetails(profile: Profile) {
        self.labelNameProfile.text = profile.name
        self.loginNameLabel.text = profile.login
        self.descriptionLabel.text = profile.bio
        
        gradientNameLabel.removeFromSuperlayer()
        gradientNameProfile.removeFromSuperlayer()
        gradientDescriptionLabel.removeFromSuperlayer()
        
    }
    
    @objc private func didTapLogoutButton() {
        onLogout()
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let imageUrl = URL(string: profileImageURL)
        else { return }
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        
        let processor = RoundCornerImageProcessor(cornerRadius: 50, backgroundColor: .clear)
        
        viewProfileImage.kf.indicatorType = .activity
        viewProfileImage.kf.setImage(with: imageUrl,
                                     placeholder: UIImage(named: "placeholder.fill"),
                                     options: [.processor(processor)])
        print(imageUrl)
        self.gradientProfileImage.removeFromSuperlayer()
    }
    
    private func onLogout() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            preferredStyle: .alert
        )
        
        let agreeAction = UIAlertAction(
            title: "Да",
            style: .default
        ) { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.onLogout()
            }
        }
        
        let dismissAction = UIAlertAction(
            title: "Нет",
            style: .default
        )
        
        alert.addAction(agreeAction)
        alert.addAction(dismissAction)
        
        present(alert, animated: true)
    }
}
