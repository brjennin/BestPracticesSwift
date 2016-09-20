@testable import BestPractices

class MockPlayer: PlayerProtocol {
    var loadedSong = false
    var capturedLoadedSong: Song?
    
    var playedSong = false
    
    func loadSong(song: Song) {
        loadedSong = true
        capturedLoadedSong = song
    }
    
    func play() {
        playedSong = true
    }
}
