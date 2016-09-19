import Quick
import Nimble
import Fleet
@testable import BestPractices

class SongSpec: QuickSpec {
    override func spec() {
        
        var subject: Song!
        
        beforeEach {
            subject = Song(name: "name")
        }
        
        it("stores off the values it is initialized with in properties") {
            expect(subject.name).to(equal("name"))
        }
        
    }
}
