import RealmSwift

protocol SongPersistenceProtocol: class {
    func replace(songs: [Song])
    
    func retrieve() -> [Song]?
}

class SongPersistence: SongPersistenceProtocol {
    
    var realm: Realm!
    
    func replace(songs: [Song]) {
        do {
            try establishConnection()
            try wipeDatabase()
        } catch {
            return
        }
        
        for song in songs {
            let songToPersist = PersistedSong()
            songToPersist.identifier = song.identifier
            songToPersist.name = song.name
            songToPersist.artist = song.artist
            songToPersist.url = song.url
            songToPersist.albumArt = song.albumArt
            
            try! self.realm.write {
                self.realm.add(songToPersist)
            }
        }
    }
    
    func retrieve() -> [Song]? {
        do {
            try establishConnection()
        } catch {
            return nil
        }
        
        let songs = realm.objects(PersistedSong.self).sorted("identifier")
        if songs.count == 0 {
            return nil
        }
        
        var result = [Song]()
        for song in songs {
            result.append(Song(identifier: song.identifier, name: song.name, artist: song.artist, url: song.url, albumArt: song.albumArt))
        }
        return result
    }
    
    private func establishConnection() throws {
        if self.realm == nil {
            self.realm = try Realm()
        }
    }
    
    private func wipeDatabase() throws {
        try self.realm.write {
            self.realm.deleteAll()
        }
    }
}
