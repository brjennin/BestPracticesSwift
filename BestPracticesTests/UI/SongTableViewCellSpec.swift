import Quick
import Nimble
import Fleet
@testable import BestPractices

class SongTableViewCellSpec: QuickSpec {
    override func spec() {
        
        var subject: SongTableViewCell!
        var titleLabel: UILabel!
        
        beforeEach {
            subject = SongTableViewCell()
            titleLabel = UILabel()
            subject.titleLabel = titleLabel
        }
        
        describe("Configuring a cell with a song") {
            beforeEach {
                let song = Song(name: "title")
                subject.configureWithSong(song)
            }
            
            it("sets the title label for the cell") {
                expect(subject.titleLabel.text).to(equal("title"))
            }
        }
        
    }
}
