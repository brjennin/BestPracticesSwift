import Foundation
@testable import BestPractices

class MockSoundService: SoundServiceProtocol {
    var calledService = false
    var completion: (([Song]?, NSError?) -> ())?

    func getSounds(completion: @escaping (([Song]?, NSError?) -> ())) {
        calledService = true
        self.completion = completion
    }

    func reset() {
        calledService = false
        completion = nil
    }
}
