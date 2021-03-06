import Quick
import Nimble
import RealmSwift
@testable import BestPractices

class SoundSpec: QuickSpec {
    override func spec() {

        var subject: Sound!

        beforeEach {
            subject = Sound(value: ["identifier": 213, "artist": "artist", "name": "name", "url": "url", "albumArt": "album"])
        }

        it("stores off the values it is initialized with in properties") {
            expect(subject.identifier).to(equal(213))
            expect(subject.name).to(equal("name"))
            expect(subject.artist).to(equal("artist"))
            expect(subject.url).to(equal("url"))
            expect(subject.albumArt).to(equal("album"))
        }

    }
}
