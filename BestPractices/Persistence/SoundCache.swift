protocol SoundCacheProtocol: class {
    func getSounds(completion: @escaping ([SoundGroup]) -> ())

    func getSoundsAndRefreshCache(completion: @escaping ([SoundGroup]) -> ())
}

class SoundCache: SoundCacheProtocol {

    var soundService: SoundServiceProtocol! = SoundService()
    var soundPersistence: SoundPersistenceProtocol! = SoundPersistence()

    func getSounds(completion: @escaping ([SoundGroup]) -> ()) {
        let persistedSounds = self.soundPersistence.retrieve()
        if let sounds = persistedSounds {
            completion(sounds)
        } else {
            self.soundService.getSounds { [weak self] soundGroups, error in
                var soundsResult = [SoundGroup]()
                if let soundGroups = soundGroups {
                    self?.soundPersistence.replace(soundGroups: soundGroups)
                    soundsResult = soundGroups
                }

                completion(soundsResult)
            }
        }
    }

    func getSoundsAndRefreshCache(completion: @escaping ([SoundGroup]) -> ()) {
        self.soundService.getSounds { [weak self] soundGroups, error in
            var soundsResult = [SoundGroup]()
            if let soundGroups = soundGroups {
                self?.soundPersistence.replace(soundGroups: soundGroups)
                soundsResult = soundGroups
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
