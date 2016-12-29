import RealmSwift

class SoundGroup: Object {
    dynamic var identifier = 0
    dynamic var name = ""
    let sounds = List<Sound>()
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
}
