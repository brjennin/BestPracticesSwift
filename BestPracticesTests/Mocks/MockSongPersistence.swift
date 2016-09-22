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
    
}
