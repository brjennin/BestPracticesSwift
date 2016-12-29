import Quick
import Nimble
import RealmSwift
@testable import BestPractices

class SoundGroupSpec: QuickSpec {
    override func spec() {
        
        var subject: SoundGroup!
        var sound: Sound!
        
        beforeEach {
            sound = Sound(value: ["identifier": 213, "artist": "artist", "name": "name", "url": "url", "albumArt": "album"])
            subject = SoundGroup(value: ["identifier": 112, "name": "blues", "sounds": [sound]])
        }
        
        it("stores off the values it is initialized with in properties") {
            expect(subject.identifier).to(equal(112))
            expect(subject.name).to(equal("blues"))
            expect(subject.sounds.first!).to(equal(sound))
        }
        
    }
}
