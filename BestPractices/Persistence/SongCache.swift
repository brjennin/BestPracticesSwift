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
            self.songService.getSongs { [weak self] songs, error in
                var songsResult = [Song]()
                if let songs = songs {
                    self?.songPersistence.replace(songs)
                    songsResult = songs
                }

                completion(songsResult)
            }
        }
    }

    func getSongsAndRefreshCache(completion: [Song] -> ()) {
        self.songService.getSongs { [weak self] songs, error in
            var songsResult = [Song]()
            if let songs = songs {
                self?.songPersistence.replace(songs)
                songsResult = songs
            } else {
                let persistedSongs = self?.songPersistence.retrieve()
                if let persistedSongs = persistedSongs {
                    songsResult = persistedSongs
                }
            }

            completion(songsResult)
        }
    }

}
