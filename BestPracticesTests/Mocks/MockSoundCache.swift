@testable import BestPractices

class MockSoundCache: SoundCacheProtocol {
    
    var calledGetSounds = false
    var capturedGetSoundsCompletion: (([Song]) -> ())?
    
    func getSounds(completion: @escaping ([Song]) -> ()) {
        calledGetSounds = true
        capturedGetSoundsCompletion = completion
    }
    
    var calledGetSoundsAndRefreshCache = false
    var capturedGetSoundsAndRefreshCacheCompletion: (([Song]) -> ())?
    
    func getSoundsAndRefreshCache(completion: @escaping (([Song]) -> ())) {
        calledGetSoundsAndRefreshCache = true
        capturedGetSoundsAndRefreshCacheCompletion = completion
    }
    
}
