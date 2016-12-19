import RealmSwift

protocol SoundPersistenceProtocol: class {
    func replace(songs: [Song])

    func retrieve() -> [Song]?
    
    func updateLocalSongUrl(song: Song, url: String)
    
    func updateLocalImageUrl(song: Song, url: String)
}

class SoundPersistence: SoundPersistenceProtocol {

    var realm: Realm!
    var diskMaster: DiskMasterProtocol! = DiskMaster()

    func replace(songs: [Song]) {
        do {
            try establishConnection()
            try wipeDatabase()
        } catch {
            return
        }

        self.diskMaster.wipeLocalStorage()
        
        for song in songs {
            _ = try? self.realm.write {
                self.realm.add(song)
            }
        }
    }

    func retrieve() -> [Song]? {
        do {
            try establishConnection()
        } catch {
            return nil
        }

        let songs = realm.objects(Song.self).sorted(byProperty: "identifier")
        if songs.count == 0 {
            return nil
        }

        var result = [Song]()
        for song in songs {
            result.append(song)
        }

        return result
    }
    
    func updateLocalSongUrl(song: Song, url: String) {
        do {
            try establishConnection()
            try realm.write {
                song.songLocalPath = url
            }
        } catch {
            return
        }
    }
    
    func updateLocalImageUrl(song: Song, url: String) {
        do {
            try establishConnection()
            try realm.write {
                song.imageLocalPath = url
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
