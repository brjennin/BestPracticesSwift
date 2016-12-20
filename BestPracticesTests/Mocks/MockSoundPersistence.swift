@testable import BestPractices

class MockSoundPersistence: SoundPersistenceProtocol {
    
    var calledReplace = false
    var capturedReplaceSounds: [Sound]?
    
    func replace(sounds: [Sound]) {
        calledReplace = true
        capturedReplaceSounds = sounds
    }
    
    var calledRetrieve = false
    var soundsThatGetRetrieved: [Sound]?
    
    func retrieve() -> [Sound]? {
        calledRetrieve = true
        return soundsThatGetRetrieved
    }
    
    var calledUpdateSoundUrl = false
    var capturedUpdateSoundUrlSound: Sound?
    var capturedUpdateSoundUrlUrl: String?
    
    func updateLocalSoundUrl(sound: Sound, url: String) {
        calledUpdateSoundUrl = true
        capturedUpdateSoundUrlSound = sound
        capturedUpdateSoundUrlUrl = url
    }
    
    var calledUpdateImageUrl = false
    var capturedUpdateImageUrlSound: Sound?
    var capturedUpdateImageUrlUrl: String?
    
    func updateLocalImageUrl(sound: Sound, url: String) {
        calledUpdateImageUrl = true
        capturedUpdateImageUrlSound = sound
        capturedUpdateImageUrlUrl = url
    }
}
