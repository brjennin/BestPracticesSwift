@testable import BestPractices

class MockActivityIndicator: ActivityIndicatorProtocol {
    var spinning = false

    var calledStart = false

    func start() {
        calledStart = true
        spinning = true
    }


    var calledStop = false

    func stop() {
        calledStop = true
        spinning = false
    }
}
