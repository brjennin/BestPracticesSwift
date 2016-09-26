import UIKit

protocol ApplicationProtocol: class {
    func beginReceivingRemoteControlEvents()
}

extension UIApplication: ApplicationProtocol {}
