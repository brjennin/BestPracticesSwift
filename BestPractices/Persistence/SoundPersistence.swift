import RealmSwift

protocol SoundPersistenceProtocol: class {
    func replace(soundGroups: [SoundGroup])

    func retrieve() -> [SoundGroup]?
    
    func updateLocalSoundUrl(sound: Sound, url: String)
    
    func updateLocalImageUrl(sound: Sound, url: String)
}

class SoundPersistence: SoundPersistenceProtocol {

    var realm: Realm!
    var diskMaster: DiskMasterProtocol! = DiskMaster()

    func replace(soundGroups: [SoundGroup]) {
        do {
            try establishConnection()
            try wipeDatabase()
        } catch {
            return
        }

        self.diskMaster.wipeLocalStorage()
        
        for soundGroup in soundGroups {
            _ = try? self.realm.write {
                self.realm.add(soundGroup)
            }
        }
    }

    func retrieve() -> [SoundGroup]? {
        do {
            try establishConnection()
        } catch {
            return nil
        }

        let soundGroups = realm.objects(SoundGroup.self).sorted(byProperty: "identifier")
        if soundGroups.count == 0 {
            return nil
        }

        var result = [SoundGroup]()
        for soundGroup in soundGroups {
            result.append(soundGroup)
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
