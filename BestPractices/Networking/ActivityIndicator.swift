import UIKit

protocol ActivityIndicatorProtocol: class {
    func start()

    func stop()
}

class ActivityIndicator: ActivityIndicatorProtocol {
    func start() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }

    func stop() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}
