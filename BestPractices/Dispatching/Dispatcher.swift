import Foundation

protocol DispatcherProtocol: class {
    func dispatchToMainQueue(completion: (() -> ()))
}

class Dispatcher: DispatcherProtocol {
    var mainQueue = NSOperationQueue.mainQueue()
    
    func dispatchToMainQueue(completion: (() -> ())) {
        self.mainQueue.addOperationWithBlock(completion)
    }
}
