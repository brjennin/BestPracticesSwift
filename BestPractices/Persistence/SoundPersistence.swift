import RealmSwift

protocol SoundPersistenceProtocol: class {
    func replace(sounds: [Song])

    func retrieve() -> [Song]?
    
    func updateLocalSoundUrl(sound: Song, url: String)
    
    func updateLocalImageUrl(sound: Song, url: String)
}

class SoundPersistence: SoundPersistenceProtocol {

    var realm: Realm!
    var diskMaster: DiskMasterProtocol! = DiskMaster()

    func replace(sounds: [Song]) {
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

    func retrieve() -> [Song]? {
        do {
            try establishConnection()
        } catch {
            return nil
        }

        let sounds = realm.objects(Song.self).sorted(byProperty: "identifier")
        if sounds.count == 0 {
            return nil
        }

        var result = [Song]()
        for sound in sounds {
            result.append(sound)
        }

        return result
    }
    
    func updateLocalSoundUrl(sound: Song, url: String) {
        do {
            try establishConnection()
            try realm.write {
                sound.songLocalPath = url
            }
        } catch {
            return
        }
    }
    
    func updateLocalImageUrl(sound: Song, url: String) {
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
