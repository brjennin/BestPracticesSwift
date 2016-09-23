@testable import BestPractices

class MockSongPersistence: SongPersistenceProtocol {
    
    var calledReplace = false
    var capturedReplaceSongs: [Song]?
    
    func replace(songs: [Song]) {
        calledReplace = true
        capturedReplaceSongs = songs
    }
    
    var calledRetrieve = false
    var songsThatGetRetrieved: [Song]?
    
    func retrieve() -> [Song]? {
        calledRetrieve = true
        return songsThatGetRetrieved
    }
    
    var calledUpdateSongUrl = false
    var capturedUpdateSongUrlSong: Song?
    var capturedUpdateSongUrlUrl: String?
    
    func updateLocalSongUrl(song: Song, url: String) {
        calledUpdateSongUrl = true
        capturedUpdateSongUrlSong = song
        capturedUpdateSongUrlUrl = url
    }
    
    var calledUpdateImageUrl = false
    var capturedUpdateImageUrlSong: Song?
    var capturedUpdateImageUrlUrl: String?
    
    func updateLocalImageUrl(song: Song, url: String) {
        calledUpdateImageUrl = true
        capturedUpdateImageUrlSong = song
        capturedUpdateImageUrlUrl = url
    }
}
