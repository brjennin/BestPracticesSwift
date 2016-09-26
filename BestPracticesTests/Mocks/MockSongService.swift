import Foundation
@testable import BestPractices

class MockSongService: SongServiceProtocol {
    var calledService = false
    var completion: (([Song]?, NSError?) -> ())?

    func getSongs(completion: (([Song]?, NSError?) -> ())) {
        calledService = true
        self.completion = completion
    }

    func reset() {
        calledService = false
        completion = nil
    }
}
