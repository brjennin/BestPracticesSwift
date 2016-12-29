@testable import BestPractices

class MockSoundCache: SoundCacheProtocol {
    
    var calledGetSounds = false
    var capturedGetSoundsCompletion: (([SoundGroup]) -> ())?
    
    func getSounds(completion: @escaping ([SoundGroup]) -> ()) {
        calledGetSounds = true
        capturedGetSoundsCompletion = completion
    }
    
    var calledGetSoundsAndRefreshCache = false
    var capturedGetSoundsAndRefreshCacheCompletion: (([SoundGroup]) -> ())?
    
    func getSoundsAndRefreshCache(completion: @escaping (([SoundGroup]) -> ())) {
        calledGetSoundsAndRefreshCache = true
        capturedGetSoundsAndRefreshCacheCompletion = completion
    }
    
}
