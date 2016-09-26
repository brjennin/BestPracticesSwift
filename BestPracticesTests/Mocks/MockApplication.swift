import UIKit
@testable import BestPractices

class MockApplication: ApplicationProtocol {
    var calledBeginReceivingRemoteControlEvents = false
    func beginReceivingRemoteControlEvents() {
        calledBeginReceivingRemoteControlEvents = true
    }
}
