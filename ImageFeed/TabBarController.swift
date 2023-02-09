import UIKit
 
final class TabBarController: UITabBarController, UITabBarControllerDelegate {
    override func awakeFromNib() {
        
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
            
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )
            
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
                    title: NSLocalizedString("", comment: ""),
                    image: UIImage(named: "tab_profile_active"),
                    selectedImage: nil
                )

       self.viewControllers = [imagesListViewController, profileViewController]
    }
    override func viewDidLoad() {
            super.viewDidLoad()
            self.tabBarController?.delegate = self
       }
}

