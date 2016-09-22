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

        let songs = realm.objects(Song.self).sorted("identifier")
        if songs.count == 0 {
            return nil
        }

        var result = [Song]()
        for song in songs {
            result.append(song)
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
