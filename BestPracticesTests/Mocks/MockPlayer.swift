@testable import BestPractices

class MockPlayer: PlayerProtocol {
    var loadedSong = false
    var capturedFilePath: String?
    
    func loadSong(filePath: String) {
        loadedSong = true
        capturedFilePath = filePath
    }
    
    var playedSong = false
    
    func play() {
        playedSong = true
    }
    
    var calledClearSong = false
    
    func clearSong() {
        calledClearSong = true
    }
}
