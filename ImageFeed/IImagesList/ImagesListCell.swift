import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reusedIdentifier = "ImagesListCell"
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dataLabel: UILabel!
    weak var delegate: ImagesListCellDelegate?
    
    
    
    @IBAction func likeButtonAction(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
        print("жмак")
    }
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
      //  cellImage.kf.cancelDownloadTask()
    }
    
    public func setIsLiked(isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.imageView?.image = likeImage
        print("лайки проставлены")
    }
}

