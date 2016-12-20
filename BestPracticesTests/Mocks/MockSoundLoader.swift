@testable import BestPractices

class MockSoundLoader: SoundLoaderProtocol {
    
    var calledLoadSoundAssets = false
    var capturedSound: Sound?
    var capturedSoundCompletion: ((Sound) -> ())?
    var capturedImageCompletion: ((Sound) -> ())?
    
    func loadSoundAssets(sound: Sound, soundCompletion: @escaping (Sound) -> (), imageCompletion: @escaping (Sound) -> ()) {
        calledLoadSoundAssets = true
        capturedSound = sound
        capturedSoundCompletion = soundCompletion
        capturedImageCompletion = imageCompletion
    }
}
