import Foundation

protocol SearchFlickrUseCase {
    func searchFlickr(for searchTerm: String, completion: @escaping (Result<FlickrSearchResults>) -> Void)
}

final class SearchFlickr: SearchFlickrUseCase {

    private let resource: FlickrResource

    init(resource: FlickrResource) {
        self.resource = resource
    }
    func searchFlickr(for searchTerm: String, completion: @escaping (Result<FlickrSearchResults>) -> Void) {
        resource.searchFlickr(for: searchTerm, completion: completion)
    }
}
