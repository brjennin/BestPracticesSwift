import SwiftyJSON

protocol SoundListDeserializerProtocol: class {
    func deserialize(json: JSON?) -> [Song]?
}

class SoundListDeserializer: SoundListDeserializerProtocol {
    func deserialize(json: JSON?) -> [Song]? {
        var songs: [Song]?

        if let json = json {
            songs = [Song]()
            for (_, subJson):(String, JSON) in json {
                let song = Song()
                song.identifier = subJson["id"].intValue
                song.name = subJson["name"].stringValue
                song.artist = subJson["artist"].stringValue
                song.url = subJson["url"].stringValue
                song.albumArt = subJson["album_art"].stringValue

                songs!.append(song)
            }
        }
        return songs
    }
}
