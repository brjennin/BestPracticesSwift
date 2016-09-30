@testable import BestPractices

class MockPlayer: PlayerProtocol {
    var loadedSong = false
    var capturedFilePath: String?
    
    func loadSong(filePath: String) {
        loadedSong = true
        capturedFilePath = filePath
    }
    
    var playedSong = false
    var capturedDelay: Bool?
    var capturedReverb: Bool?
    
    func play(delay: Bool, reverb: Bool) {
        playedSong = true
        capturedDelay = delay
        capturedReverb = reverb
    }
    
    var calledClearSong = false
    
    func clearSong() {
        calledClearSong = true
    }
    
    var calledPitchShift = false
    var capturedPitchShiftAmount: Float?
    
    func pitchShift(amount: Float) {
        calledPitchShift = true
        capturedPitchShiftAmount = amount
    }
}
