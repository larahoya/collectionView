import UIKit

class FlickrPhoto {
    var thumbnail: UIImage?
    var largeImage: UIImage?
    let photoID: String
    let farm: Int
    let server: String
    let secret: String

    init (photoID: String, farm: Int, server: String, secret: String) {
        self.photoID = photoID
        self.farm = farm
        self.server = server
        self.secret = secret
    }

    func flickrImageURL(_ size: String = "m") -> URL? {
        guard let url =  URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_\(size).jpg") else { return nil }
        return url
    }
}

extension FlickrPhoto: Equatable {
    static func ==(lhs: FlickrPhoto, rhs: FlickrPhoto) -> Bool {
        return lhs.photoID == rhs.photoID
    }
}
