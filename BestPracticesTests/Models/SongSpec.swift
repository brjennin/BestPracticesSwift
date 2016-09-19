import Quick
import Nimble
import Fleet
@testable import BestPractices

class SongSpec: QuickSpec {
    override func spec() {
        
        var subject: Song!
        
        beforeEach {
            subject = Song(identifier: 213, name: "name", artist: "artist", url: "url", albumArt: "album")
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
