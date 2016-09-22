@testable import BestPractices

class MockSongCache: SongCacheProtocol {
    
    var calledGetSongs = false
    var capturedGetSongsCompletion: ([Song] -> ())?
    
    func getSongs(completion: [Song] -> ()) {
        calledGetSongs = true
        capturedGetSongsCompletion = completion
    }
    
    var calledGetSongsAndRefreshCache = false
    var capturedGetSongsAndRefreshCacheCompletion: ([Song] -> ())?
    
    func getSongsAndRefreshCache(completion: ([Song] -> ())) {
        calledGetSongsAndRefreshCache = true
        capturedGetSongsAndRefreshCacheCompletion = completion
    }
    
}
