import RealmSwift

class Song: Object {
    dynamic var identifier = 0
    dynamic var name = ""
    dynamic var artist = ""
    dynamic var url = ""
    dynamic var albumArt = ""

    override static func primaryKey() -> String? {
        return "identifier"
    }
}
