import Foundation

final class MainPresenter {

    private let searchFlickr: SearchFlickrUseCase

    init(searchFlickr: SearchFlickrUseCase) {
        self.searchFlickr = searchFlickr
    }
}
