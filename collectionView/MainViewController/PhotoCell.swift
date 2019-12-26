import UIKit

class PhotoCell: UICollectionViewCell {

    static let reuseIdentifier = "PhotoCell"
    @IBOutlet private weak var imageView: UIImageView!

    func setImage(_ image: UIImage) {
        imageView.image = image
    }
}
