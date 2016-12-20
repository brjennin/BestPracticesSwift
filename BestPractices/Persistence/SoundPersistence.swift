import RealmSwift

protocol SoundPersistenceProtocol: class {
    func replace(sounds: [Sound])

    func retrieve() -> [Sound]?
    
    func updateLocalSoundUrl(sound: Sound, url: String)
    
    func updateLocalImageUrl(sound: Sound, url: String)
}

class SoundPersistence: SoundPersistenceProtocol {

    var realm: Realm!
    var diskMaster: DiskMasterProtocol! = DiskMaster()

    func replace(sounds: [Sound]) {
        do {
            try establishConnection()
            try wipeDatabase()
        } catch {
            return
        }

        self.diskMaster.wipeLocalStorage()
        
        for sound in sounds {
            _ = try? self.realm.write {
                self.realm.add(sound)
            }
        }
    }

    func retrieve() -> [Sound]? {
        do {
            try establishConnection()
        } catch {
            return nil
        }

        let sounds = realm.objects(Sound.self).sorted(byProperty: "identifier")
        if sounds.count == 0 {
            return nil
        }

        var result = [Sound]()
        for sound in sounds {
            result.append(sound)
        }

        return result
    }
    
    func updateLocalSoundUrl(sound: Sound, url: String) {
        do {
            try establishConnection()
            try realm.write {
                sound.soundLocalPath = url
            }
        } catch {
            return
        }
    }
    
    func updateLocalImageUrl(sound: Sound, url: String) {
        do {
            try establishConnection()
            try realm.write {
                sound.imageLocalPath = url
            }
        } catch {
            return
        }
    }

    fileprivate func establishConnection() throws {
        if self.realm == nil {
            self.realm = try Realm()
        }
    }

    fileprivate func wipeDatabase() throws {
        try self.realm.write {
            self.realm.deleteAll()
        }
    }
}
