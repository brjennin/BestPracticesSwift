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
    
    func play(delay: Bool) {
        playedSong = true
        capturedDelay = delay
    }
    
    var calledClearSong = false
    
    func clearSong() {
        calledClearSong = true
    }
}
