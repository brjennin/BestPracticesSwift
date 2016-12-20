protocol SoundCacheProtocol: class {
    func getSounds(completion: @escaping ([Song]) -> ())

    func getSoundsAndRefreshCache(completion: @escaping ([Song]) -> ())
}

class SoundCache: SoundCacheProtocol {

    var soundService: SoundServiceProtocol! = SoundService()
    var soundPersistence: SoundPersistenceProtocol! = SoundPersistence()

    func getSounds(completion: @escaping ([Song]) -> ()) {
        let persistedSounds = self.soundPersistence.retrieve()
        if let sounds = persistedSounds {
            completion(sounds)
        } else {
            self.soundService.getSounds { [weak self] sounds, error in
                var soundsResult = [Song]()
                if let sounds = sounds {
                    self?.soundPersistence.replace(sounds: sounds)
                    soundsResult = sounds
                }

                completion(soundsResult)
            }
        }
    }

    func getSoundsAndRefreshCache(completion: @escaping ([Song]) -> ()) {
        self.soundService.getSounds { [weak self] sounds, error in
            var soundsResult = [Song]()
            if let sounds = sounds {
                self?.soundPersistence.replace(sounds: sounds)
                soundsResult = sounds
            } else {
                let persistedSounds = self?.soundPersistence.retrieve()
                if let persistedSounds = persistedSounds {
                    soundsResult = persistedSounds
                }
            }

            completion(soundsResult)
        }
    }

}
