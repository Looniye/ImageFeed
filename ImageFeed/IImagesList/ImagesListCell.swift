import UIKit

final class ImagesListCell: UITableViewCell {
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dataLabel: UILabel!
    static let reusedIdentifier = "ImagesListCell"
}

