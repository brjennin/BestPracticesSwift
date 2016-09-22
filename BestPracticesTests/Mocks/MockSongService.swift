@testable import BestPractices

class MockSongService: SongServiceProtocol {
    var calledService = false
    var completion: ([Song] -> ())?
    
    func getSongs(completion: ([Song] -> ())) {
        calledService = true
        self.completion = completion
    }
    
    func reset() {
        calledService = false
        completion = nil
    }
}
