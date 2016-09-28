import UIKit

protocol ActivityIndicatorProtocol: class {
    func start()

    func stop()
}

class ActivityIndicator: ActivityIndicatorProtocol {
    func start() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func stop() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
