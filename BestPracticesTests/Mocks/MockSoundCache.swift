@testable import BestPractices

class MockSoundCache: SoundCacheProtocol {
    
    var calledGetSounds = false
    var capturedGetSoundsCompletion: (([Sound]) -> ())?
    
    func getSounds(completion: @escaping ([Sound]) -> ()) {
        calledGetSounds = true
        capturedGetSoundsCompletion = completion
    }
    
    var calledGetSoundsAndRefreshCache = false
    var capturedGetSoundsAndRefreshCacheCompletion: (([Sound]) -> ())?
    
    func getSoundsAndRefreshCache(completion: @escaping (([Sound]) -> ())) {
        calledGetSoundsAndRefreshCache = true
        capturedGetSoundsAndRefreshCacheCompletion = completion
    }
    
}
