import UIKit

protocol MainViewDelegate: class {
    func add(searchResults: FlickrSearchResults)
}

final class MainViewController: UIViewController {

    private let presenter: MainPresenter

    init(presenter: MainPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)

        presenter.mainViewDelegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self

        let bundle = Bundle(for: PhotoCell.self)
        let nib = UINib(nibName: NSStringFromClass(PhotoCell.self).components(separatedBy: ".").last!, bundle: bundle)
        collectionView.register(nib, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let itemsPerLine: CGFloat = 3
    private let defaultMargin: CGFloat = 8

    private var items: [FlickrSearchResults] = []

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!

    private func getPhoto(for indexPath: IndexPath) -> FlickrPhoto {
        return items[indexPath.section].searchResults[indexPath.row]
    }
}

extension MainViewController: MainViewDelegate {
    func add(searchResults: FlickrSearchResults) {
        items.append(searchResults)
        collectionView.reloadData()
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        presenter.onUserSearch(text: textField.text!)
        return true
    }
}

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items[section].searchResults.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as! PhotoCell
        if let image = getPhoto(for: indexPath).thumbnail {
            cell.setImage(image)
        }
        return cell
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let size = (collectionViewWidth - (defaultMargin * (itemsPerLine + 3))) / itemsPerLine
        return CGSize(width: size, height: size)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: defaultMargin, left: defaultMargin, bottom: defaultMargin, right: defaultMargin)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return defaultMargin
    }
}
