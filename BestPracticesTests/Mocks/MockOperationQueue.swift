import Foundation
@testable import BestPractices

class MockOperationQueue: NSOperationQueue {
    var completion: (() -> ())?
    
    override func addOperationWithBlock(block: () -> Void) {
        completion = block
    }
}
