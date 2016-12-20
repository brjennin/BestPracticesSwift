import Quick
import Nimble
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

        describe("Configuring a cell with a sound") {
            beforeEach {
                let sound = Sound(value: ["name": "title"])
                subject.configureWithSound(sound: sound)
            }

            it("sets the title label for the cell") {
                expect(subject.titleLabel.text).to(equal("title"))
            }
        }

    }
}
