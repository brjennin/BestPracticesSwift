@testable import BestPractices

class MockDispatcher: DispatcherProtocol {
    var calledDispatch = false
    
    func dispatchToMainQueue(completion: (() -> ())) {
        calledDispatch = true
        completion()
    }
}
