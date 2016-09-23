import RealmSwift

class Song: Object {
    dynamic var identifier = 0
    dynamic var name = ""
    dynamic var artist = ""
    dynamic var url = ""
    dynamic var albumArt = ""
    dynamic var songLocalPath: String? = nil
    dynamic var imageLocalPath: String? = nil

    override static func primaryKey() -> String? {
        return "identifier"
    }
}
