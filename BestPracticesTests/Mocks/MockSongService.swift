@testable import BestPractices

class MockSongService: SongServiceProtocol {
    var calledService = false
    var completion: ([Song]) -> () = {_ in }
    
    func getSongs(completion: (([Song]) -> ())) {
        calledService = true
        self.completion = completion
    }
}
