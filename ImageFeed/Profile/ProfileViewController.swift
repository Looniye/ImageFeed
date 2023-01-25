import UIKit
import Kingfisher

final class ProfileViewController: UIViewController{
    private var viewProfileImage = UIImageView()
    private var labelNameProfile = UILabel()
    private var loginNameLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var buttonLogout = UIButton()
    
    private var profileService = ProfileService.shared
    private(set) var profile: Profile?
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP Black")
        setUI()
        
        guard let profile = profileService.profile else {return}
        updateProfileDetails(profile: profile)
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.DidChangeNotification,
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
        
    }
    
    @objc private func didTapLogoutButton() { }
    
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
    }
}
