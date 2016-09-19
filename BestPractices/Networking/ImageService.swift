import UIKit

protocol ImageServiceProtocol: class {
    func getImage(url: String, completion: ((UIImage?) -> ()))
}

class ImageService: ImageServiceProtocol {
    var httpClient: HTTPClientProtocol! = HTTPClient()

    func getImage(url: String, completion: ((UIImage?) -> ())) {
        self.httpClient.makeDataRequest(url) { data in
            var image: UIImage?
            if let imageData = data {
                image = UIImage.init(data: imageData)
            }
            completion(image)
        }
    }
}
