import Foundation
@testable import BestPractices

class MockSoundService: SoundServiceProtocol {
    var calledService = false
    var completion: (([Sound]?, NSError?) -> ())?

    func getSounds(completion: @escaping (([Sound]?, NSError?) -> ())) {
        calledService = true
        self.completion = completion
    }

    func reset() {
        calledService = false
        completion = nil
    }
}
