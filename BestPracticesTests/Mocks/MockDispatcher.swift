@testable import BestPractices

class MockDispatcher: DispatcherProtocol {
    var calledDispatch = false
    
    func dispatchToMainQueue(completion: @escaping (() -> ())) {
        calledDispatch = true
        completion()
    }
}
