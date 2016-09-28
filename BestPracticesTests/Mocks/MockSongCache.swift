@testable import BestPractices

class MockSongCache: SongCacheProtocol {
    
    var calledGetSongs = false
    var capturedGetSongsCompletion: (([Song]) -> ())?
    
    func getSongs(completion: @escaping ([Song]) -> ()) {
        calledGetSongs = true
        capturedGetSongsCompletion = completion
    }
    
    var calledGetSongsAndRefreshCache = false
    var capturedGetSongsAndRefreshCacheCompletion: (([Song]) -> ())?
    
    func getSongsAndRefreshCache(completion: @escaping (([Song]) -> ())) {
        calledGetSongsAndRefreshCache = true
        capturedGetSongsAndRefreshCacheCompletion = completion
    }
    
}
