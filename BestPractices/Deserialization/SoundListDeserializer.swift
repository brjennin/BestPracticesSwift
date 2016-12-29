import SwiftyJSON

protocol SoundListDeserializerProtocol: class {
    func deserialize(json: JSON?) -> [SoundGroup]?
}

class SoundListDeserializer: SoundListDeserializerProtocol {
    func deserialize(json: JSON?) -> [SoundGroup]? {
        var soundGroups: [SoundGroup]?

        if let json = json {
            soundGroups = [SoundGroup]()
            
            for (_, groupJson):(String, JSON) in json {
                let soundGroup = SoundGroup()
                soundGroup.identifier = groupJson["id"].intValue
                soundGroup.name = groupJson["group"].stringValue
                
                var sounds = [Sound]()
                for soundJson in groupJson["sounds"].arrayValue {
                    let sound = Sound()
                    sound.identifier = soundJson["id"].intValue
                    sound.name = soundJson["name"].stringValue
                    sound.artist = soundJson["artist"].stringValue
                    sound.url = soundJson["url"].stringValue
                    sound.albumArt = soundJson["album_art"].stringValue
                    
                    sounds.append(sound)
                }
                soundGroup.sounds.append(objectsIn: sounds)
                
                soundGroups!.append(soundGroup)
            }
        }
        return soundGroups
    }
}
