import Foundation
@testable import BestPractices

class MockOperationQueue: OperationQueue {
    var completion: (() -> ())?
    
    override func addOperation(_ block: @escaping () -> Void) {
        completion = block
    }
}
