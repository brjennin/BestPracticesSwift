import SwiftyJSON

protocol SongListDeserializerProtocol: class {
    func deserialize(json: JSON?) -> [Song]
}

class SongListDeserializer: SongListDeserializerProtocol {
    func deserialize(json: JSON?) -> [Song] {
        var songs = [Song]()

        if let json = json {
            for (_, subJson):(String, JSON) in json {
                let song = Song(identifier: subJson["id"].intValue,
                                name: subJson["name"].stringValue,
                                artist: subJson["artist"].stringValue,
                                url: subJson["url"].stringValue,
                                albumArt: subJson["album_art"].stringValue)
                songs.append(song)
            }
        }
        return songs
    }
}
