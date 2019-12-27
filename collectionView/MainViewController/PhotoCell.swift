import UIKit

class PhotoCell: UICollectionViewCell {

    static let reuseIdentifier = "PhotoCell"
    @IBOutlet private weak var imageView: UIImageView!

    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.borderWidth = 1
                layer.borderColor = UIColor.red.cgColor
            } else {
                layer.borderWidth = 0
            }
        }
    }

    func setImage(_ image: UIImage) {
        imageView.image = image
    }
}
