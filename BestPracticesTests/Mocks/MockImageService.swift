import UIKit
@testable import BestPractices

class MockImageService: ImageServiceProtocol {
    var calledService = false
    var capturedURL: String?
    var completion: (UIImage?) -> () = {_ in }

    func getImage(url: String, completion: ((UIImage?) -> ())) {
        calledService = true
        capturedURL = url
        self.completion = completion
    }
}
