import SwiftyJSON

protocol SoundListDeserializerProtocol: class {
    func deserialize(json: JSON?) -> [Sound]?
}

class SoundListDeserializer: SoundListDeserializerProtocol {
    func deserialize(json: JSON?) -> [Sound]? {
        var sounds: [Sound]?

        if let json = json {
            sounds = [Sound]()
            for (_, subJson):(String, JSON) in json {
                let sound = Sound()
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
