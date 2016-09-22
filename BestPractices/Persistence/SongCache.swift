protocol SongCacheProtocol: class {
    func getSongs(completion: [Song] -> ())
    
    func getSongsAndRefreshCache(completion: [Song] -> ())
}

class SongCache: SongCacheProtocol {
    
    var songService: SongServiceProtocol! = SongService()
    var songPersistence: SongPersistenceProtocol! = SongPersistence()
    
    func getSongs(completion: [Song] -> ()) {
        let persistedSongs = self.songPersistence.retrieve()
        if let songs = persistedSongs {
            completion(songs)
        } else {
            getSongsAndRefreshCache(completion)
        }
    }
    
    func getSongsAndRefreshCache(completion: [Song] -> ()) {
        self.songService.getSongs { songs in
            self.songPersistence.replace(songs)
            completion(songs)
        }
    }
    
}
