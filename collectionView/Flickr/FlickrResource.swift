import UIKit
import Foundation

enum Result<ResultType> {
  case results(ResultType)
  case error(Error)
}

class FlickrResource {

    let apiKey = "a7c3ac4294f80f5d7e3d0e67c738f4a0"

    enum Error: Swift.Error {
        case unknownAPIResponse
        case invalidURL
        case generic
    }

    func searchFlickr(for searchTerm: String, completion: @escaping (Result<FlickrSearchResults>) -> Void) {
        guard let searchURL = flickrSearchURL(for: searchTerm) else {
            completion(Result.error(Error.unknownAPIResponse))
            return
        }

        let searchRequest = URLRequest(url: searchURL)

        URLSession.shared
            .dataTask(with: searchRequest) { (data, response, error) in
                guard error == nil else {
                    DispatchQueue.main.async {
                        completion(Result.error(error!))
                    }
                    return
                }

                guard let _ = response as? HTTPURLResponse, let data = data else {
                    DispatchQueue.main.async {
                        completion(Result.error(Error.unknownAPIResponse))
                    }
                    return
                }

                guard let resultsDictionary = try? JSONSerialization.jsonObject(with: data) as? [String: AnyObject],
                    let stat = resultsDictionary["stat"] as? String, stat == "ok",
                    let photosContainer = resultsDictionary["photos"] as? [String: AnyObject],
                    let photosReceived = photosContainer["photo"] as? [[String: AnyObject]] else {
                        DispatchQueue.main.async {
                            completion(Result.error(Error.unknownAPIResponse))
                        }
                        return
                }

                let flickrPhotos: [FlickrPhoto] = photosReceived.compactMap { photoObject in
                    guard let photoID = photoObject["id"] as? String,
                        let farm = photoObject["farm"] as? Int ,
                        let server = photoObject["server"] as? String ,
                        let secret = photoObject["secret"] as? String
                        else {
                            return nil
                    }

                    let flickrPhoto = FlickrPhoto(photoID: photoID, farm: farm, server: server, secret: secret)

                    guard let url = flickrPhoto.flickrImageURL(),
                        let imageData = try? Data(contentsOf: url as URL),
                        let image = UIImage(data: imageData)
                        else {
                            return nil
                    }

                    flickrPhoto.thumbnail = image
                    return flickrPhoto
                }

                let searchResults = FlickrSearchResults(searchTerm: searchTerm, searchResults: flickrPhotos)
                DispatchQueue.main.async {
                    completion(Result.results(searchResults))
                }
        }.resume()
    }

    func loadLargeImage(photo: FlickrPhoto, completion: @escaping (Result<FlickrPhoto>) -> Void) {
        guard let loadURL = photo.flickrImageURL("b") else {
            DispatchQueue.main.async {
                completion(Result.error(Error.invalidURL))
            }
            return
        }

        let loadRequest = URLRequest(url:loadURL)

        URLSession.shared
            .dataTask(with: loadRequest) { (data, response, error) in
                guard error == nil, let data = data else {
                    DispatchQueue.main.async {
                        completion(Result.error(Error.generic))
                    }
                    return
                }

                photo.largeImage = UIImage(data: data)
                DispatchQueue.main.async {
                    completion(Result.results(photo))
                }
        }.resume()
    }

    private func flickrSearchURL(for searchTerm: String) -> URL? {
        guard let escapedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else { return nil }
        let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(escapedTerm)&per_page=20&format=json&nojsoncallback=1"
        return URL(string: URLString)
    }
}
