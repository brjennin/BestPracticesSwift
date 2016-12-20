@testable import BestPractices

class MockSoundPersistence: SoundPersistenceProtocol {
    
    var calledReplace = false
    var capturedReplaceSounds: [Song]?
    
    func replace(sounds: [Song]) {
        calledReplace = true
        capturedReplaceSounds = sounds
    }
    
    var calledRetrieve = false
    var soundsThatGetRetrieved: [Song]?
    
    func retrieve() -> [Song]? {
        calledRetrieve = true
        return soundsThatGetRetrieved
    }
    
    var calledUpdateSoundUrl = false
    var capturedUpdateSoundUrlSound: Song?
    var capturedUpdateSoundUrlUrl: String?
    
    func updateLocalSoundUrl(sound: Song, url: String) {
        calledUpdateSoundUrl = true
        capturedUpdateSoundUrlSound = sound
        capturedUpdateSoundUrlUrl = url
    }
    
    var calledUpdateImageUrl = false
    var capturedUpdateImageUrlSound: Song?
    var capturedUpdateImageUrlUrl: String?
    
    func updateLocalImageUrl(sound: Song, url: String) {
        calledUpdateImageUrl = true
        capturedUpdateImageUrlSound = sound
        capturedUpdateImageUrlUrl = url
    }
}
