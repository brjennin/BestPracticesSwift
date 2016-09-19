@testable import BestPractices

class MockSongSelectionDelegate: SongSelectionDelegate {
    var calledDelegate = false
    var capturedSong: Song?
    
    func songWasSelected(song: Song) {
        self.calledDelegate = true
        self.capturedSong = song
    }
}
