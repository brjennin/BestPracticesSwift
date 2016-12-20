import SwiftyJSON

protocol SoundListDeserializerProtocol: class {
    func deserialize(json: JSON?) -> [Song]?
}

class SoundListDeserializer: SoundListDeserializerProtocol {
    func deserialize(json: JSON?) -> [Song]? {
        var sounds: [Song]?

        if let json = json {
            sounds = [Song]()
            for (_, subJson):(String, JSON) in json {
                let sound = Song()
                sound.identifier = subJson["id"].intValue
                sound.name = subJson["name"].stringValue
                sound.artist = subJson["artist"].stringValue
                sound.url = subJson["url"].stringValue
                sound.albumArt = subJson["album_art"].stringValue

                sounds!.append(sound)
            }
        }
        return sounds
    }
}
