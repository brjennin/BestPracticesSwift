protocol SoundCacheProtocol: class {
    func getSounds(completion: @escaping ([Sound]) -> ())

    func getSoundsAndRefreshCache(completion: @escaping ([Sound]) -> ())
}

class SoundCache: SoundCacheProtocol {

    var soundService: SoundServiceProtocol! = SoundService()
    var soundPersistence: SoundPersistenceProtocol! = SoundPersistence()

    func getSounds(completion: @escaping ([Sound]) -> ()) {
        let persistedSounds = self.soundPersistence.retrieve()
        if let sounds = persistedSounds {
            completion(sounds)
        } else {
            self.soundService.getSounds { [weak self] sounds, error in
                var soundsResult = [Sound]()
                if let sounds = sounds {
                    self?.soundPersistence.replace(sounds: sounds)
                    soundsResult = sounds
                }

                completion(soundsResult)
            }
        }
    }

    func getSoundsAndRefreshCache(completion: @escaping ([Sound]) -> ()) {
        self.soundService.getSounds { [weak self] sounds, error in
            var soundsResult = [Sound]()
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
