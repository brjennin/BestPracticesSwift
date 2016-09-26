import UIKit

protocol ApplicationProviderProtocol: class {
    func sharedApplication() -> ApplicationProtocol
}

class ApplicationProvider: ApplicationProviderProtocol {
    func sharedApplication() -> ApplicationProtocol {
        return UIApplication.sharedApplication()
    }
}
