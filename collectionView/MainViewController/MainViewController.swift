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
        configureCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let itemsPerLine: CGFloat = 3
    private let defaultMargin: CGFloat = 8

    private var items: [FlickrSearchResults] = []
    private var selectedItem: String?

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!

    private func getPhoto(for indexPath: IndexPath) -> FlickrPhoto {
        return items[indexPath.section].searchResults[indexPath.row]
    }

    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self

        let bundle = Bundle(for: PhotoCell.self)
        let nib = UINib(nibName: NSStringFromClass(PhotoCell.self).components(separatedBy: ".").last!, bundle: bundle)
        collectionView.register(nib, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)

        let headerBundle = Bundle(for: MainCollectionViewHeader.self)
        let headerNib = UINib(nibName: NSStringFromClass(MainCollectionViewHeader.self).components(separatedBy: ".").last!, bundle: headerBundle)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainCollectionViewHeader.reuseIdentifier)
    }
}

extension MainViewController: MainViewDelegate {
    func add(searchResults: FlickrSearchResults) {
        items.insert(searchResults, at: 0)
        collectionView.reloadData()
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        presenter.onUserSearch(text: textField.text!)
        textField.text = ""
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
        let image = getPhoto(for: indexPath)
        if let thumbnail = image.thumbnail {
            cell.setImage(thumbnail)
        }
        cell.isSelected = image.photoID == selectedItem
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header: MainCollectionViewHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MainCollectionViewHeader.reuseIdentifier, for: indexPath) as! MainCollectionViewHeader
        let title = items[indexPath.section].searchTerm
        header.setTitle(title: title)
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 48)
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPhotoID = getPhoto(for: indexPath).photoID
        if selectedItem == selectedPhotoID {
            selectedItem = nil
        } else {
            selectedItem = selectedPhotoID
        }
        collectionView.reloadData()
    }
}
