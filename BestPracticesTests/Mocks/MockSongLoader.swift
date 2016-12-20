@testable import BestPractices

class MockSongLoader: SongLoaderProtocol {
    
    var calledLoadSoundAssets = false
    var capturedSound: Song?
    var capturedSoundCompletion: ((Song) -> ())?
    var capturedImageCompletion: ((Song) -> ())?
    
    func loadSoundAssets(sound: Song, soundCompletion: @escaping (Song) -> (), imageCompletion: @escaping (Song) -> ()) {
        calledLoadSoundAssets = true
        capturedSound = sound
        capturedSoundCompletion = soundCompletion
        capturedImageCompletion = imageCompletion
    }
}
