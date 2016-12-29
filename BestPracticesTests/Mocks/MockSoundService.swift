import Foundation
@testable import BestPractices

class MockSoundService: SoundServiceProtocol {
    var calledService = false
    var completion: (([SoundGroup]?, NSError?) -> ())?

    func getSounds(completion: @escaping (([SoundGroup]?, NSError?) -> ())) {
        calledService = true
        self.completion = completion
    }

    func reset() {
        calledService = false
        completion = nil
    }
}
