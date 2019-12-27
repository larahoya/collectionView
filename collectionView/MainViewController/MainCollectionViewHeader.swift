import UIKit

class MainCollectionViewHeader: UICollectionReusableView {

    static let reuseIdentifier = "MainCollectionViewHeader"

    @IBOutlet private weak var titleLabel: UILabel!

    func setTitle(title: String) {
        titleLabel.text = title
        backgroundColor = .lightGray
    }
}
