protocol SoundCacheProtocol: class {
    func getSongs(completion: @escaping ([Song]) -> ())

    func getSongsAndRefreshCache(completion: @escaping ([Song]) -> ())
}

class SoundCache: SoundCacheProtocol {

    var soundService: SoundServiceProtocol! = SoundService()
    var soundPersistence: SoundPersistenceProtocol! = SoundPersistence()

    func getSongs(completion: @escaping ([Song]) -> ()) {
        let persistedSongs = self.soundPersistence.retrieve()
        if let songs = persistedSongs {
            completion(songs)
        } else {
            self.soundService.getSongs { [weak self] songs, error in
                var songsResult = [Song]()
                if let songs = songs {
                    self?.soundPersistence.replace(songs: songs)
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
                self?.soundPersistence.replace(songs: songs)
                songsResult = songs
            } else {
                let persistedSongs = self?.soundPersistence.retrieve()
                if let persistedSongs = persistedSongs {
                    songsResult = persistedSongs
                }
            }

            completion(songsResult)
        }
    }

}
