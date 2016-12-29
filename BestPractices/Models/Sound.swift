import RealmSwift

class Sound: Object {
    dynamic var identifier = 0
    dynamic var name = ""
    dynamic var artist = ""
    dynamic var url = ""
    dynamic var albumArt = ""
    dynamic var soundLocalPath: String? = nil
    dynamic var imageLocalPath: String? = nil

    override static func primaryKey() -> String? {
        return "identifier"
    }
}
