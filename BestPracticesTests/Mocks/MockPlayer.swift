@testable import BestPractices

class MockPlayer: PlayerProtocol {
    var loadedSound = false
    var capturedFilePath: String?
    
    func loadSound(filePath: String) {
        loadedSound = true
        capturedFilePath = filePath
    }
    
    var playedSound = false
    var capturedDelay: Bool?
    var capturedReverb: Bool?
    
    func play(delay: Bool, reverb: Bool) {
        playedSound = true
        capturedDelay = delay
        capturedReverb = reverb
    }
    
    var calledClearSound = false
    
    func clearSound() {
        calledClearSound = true
    }
    
    var calledPitchShift = false
    var capturedPitchShiftAmount: Float?
    
    func pitchShift(amount: Float) {
        calledPitchShift = true
        capturedPitchShiftAmount = amount
    }
}
