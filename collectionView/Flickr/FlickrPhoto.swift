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

    func sizeToFillWidth(of size:CGSize) -> CGSize {
        guard let thumbnail = thumbnail else { return size }

        let imageSize = thumbnail.size
        var returnSize = size

        let aspectRatio = imageSize.width / imageSize.height

        returnSize.height = returnSize.width / aspectRatio

        if returnSize.height > size.height {
            returnSize.height = size.height
            returnSize.width = size.height * aspectRatio
        }

        return returnSize
    }
}

extension FlickrPhoto: Equatable {
    static func ==(lhs: FlickrPhoto, rhs: FlickrPhoto) -> Bool {
        return lhs.photoID == rhs.photoID
    }
}
