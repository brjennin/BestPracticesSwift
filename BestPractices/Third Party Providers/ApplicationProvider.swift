import UIKit

protocol ApplicationProtocol: class {
    func beginReceivingRemoteControlEvents()
}

extension UIApplication: ApplicationProtocol {}


protocol ApplicationProviderProtocol: class {
    func sharedApplication() -> ApplicationProtocol
}

class ApplicationProvider: ApplicationProviderProtocol {
    func sharedApplication() -> ApplicationProtocol {
        return UIApplication.shared
    }
}
