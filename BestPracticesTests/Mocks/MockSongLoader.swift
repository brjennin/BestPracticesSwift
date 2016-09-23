@testable import BestPractices

class MockSongLoader: SongLoaderProtocol {
    
    var calledLoadSongAssets = false
    var capturedSong: Song?
    var capturedSongCompletion: ((Song) -> ())?
    var capturedImageCompletion: ((Song) -> ())?
    
    func loadSongAssets(song: Song, songCompletion: (Song) -> (), imageCompletion: (Song) -> ()) {
        calledLoadSongAssets = true
        capturedSong = song
        capturedSongCompletion = songCompletion
        capturedImageCompletion = imageCompletion
    }
}
