protocol SongCacheProtocol: class {
    func getSongs(completion: @escaping ([Song]) -> ())

    func getSongsAndRefreshCache(completion: @escaping ([Song]) -> ())
}

class SongCache: SongCacheProtocol {

    var soundService: SoundServiceProtocol! = SoundService()
    var songPersistence: SongPersistenceProtocol! = SongPersistence()

    func getSongs(completion: @escaping ([Song]) -> ()) {
        let persistedSongs = self.songPersistence.retrieve()
        if let songs = persistedSongs {
            completion(songs)
        } else {
            self.soundService.getSongs { [weak self] songs, error in
                var songsResult = [Song]()
                if let songs = songs {
                    self?.songPersistence.replace(songs: songs)
                    songsResult = songs
                }

                completion(songsResult)
            }
        }
    }

    func getSongsAndRefreshCache(completion: @escaping ([Song]) -> ()) {
        self.soundService.getSongs { [weak self] songs, error in
            var songsResult = [Song]()
            if let songs = songs {
                self?.songPersistence.replace(songs: songs)
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
