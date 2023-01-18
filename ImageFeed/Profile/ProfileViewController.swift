import UIKit

final class ProfileViewController: UIViewController{
    private var viewProfileImage = UIImageView()
    private var labelNameProfile = UILabel()
    private var loginNameLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var buttonLogout = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view = UIView()
        view.backgroundColor = UIColor(named: "YP Black")

        let imageProfile = UIImage(named: "UserPhoto")
        let imageButton = UIImage(named: "logout")

        viewProfileImage = UIImageView(image: imageProfile)
        viewProfileImage.tintColor = .gray
        viewProfileImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewProfileImage)

        labelNameProfile = UILabel()
        labelNameProfile.text = "Екатерина Новикова"
        labelNameProfile.textColor = UIColor(named: "YP White")
        labelNameProfile.font = UIFont.systemFont(ofSize: 23)
        labelNameProfile.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelNameProfile)

        loginNameLabel = UILabel()
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.textColor = UIColor(named: "YP Gray")
        loginNameLabel.font = UIFont.systemFont(ofSize: 13)
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)

        descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = UIColor(named: "YP White")
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)

        buttonLogout = UIButton.systemButton(with: imageButton!,
                                                 target: self,
                                                 action: #selector(didTapLogoutButton))
        
        buttonLogout.tintColor = UIColor(named: "YP Red")
        buttonLogout.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonLogout)

        NSLayoutConstraint.activate([
            viewProfileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            viewProfileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            viewProfileImage.widthAnchor.constraint(equalToConstant: 70),
            viewProfileImage.heightAnchor.constraint(equalToConstant: 70),

            labelNameProfile.topAnchor.constraint(equalTo: viewProfileImage.bottomAnchor, constant: 8),
            labelNameProfile.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),

            loginNameLabel.topAnchor.constraint(equalTo: labelNameProfile.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),

            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),

            buttonLogout.centerYAnchor.constraint(equalTo: viewProfileImage.centerYAnchor),
            buttonLogout.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26)
        ])
    }
    
    @objc func didTapLogoutButton() { }
}
