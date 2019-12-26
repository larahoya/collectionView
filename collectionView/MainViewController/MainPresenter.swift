import Foundation

final class MainPresenter {

    private let searchFlickr: SearchFlickrUseCase
    weak var mainViewDelegate: MainViewDelegate?

    init(searchFlickr: SearchFlickrUseCase) {
        self.searchFlickr = searchFlickr
    }

    func onUserSearch(text: String?) {
        searchFlickr.searchFlickr(for: text!) { [weak self] result in
            switch result {
            case .results(let searchResult):
                self?.mainViewDelegate?.add(searchResults: searchResult)
            case .error:
                break
            }
        }
    }
}
