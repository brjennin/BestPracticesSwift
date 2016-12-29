import Quick
import Nimble
@testable import BestPractices

class SectionHeaderViewCellSpec: QuickSpec {
    override func spec() {
        
        var subject: SectionHeaderViewCell!
        var titleLabel: UILabel!
        
        beforeEach {
            subject = SectionHeaderViewCell()
            titleLabel = UILabel()
            subject.titleLabel = titleLabel
        }
        
        describe("Configuring a cell with a title") {
            beforeEach {
                subject.configureWithTitle(title: "Spunk")
            }
            
            it("sets the title label for the cell") {
                expect(subject.titleLabel.text).to(equal("SPUNK"))
            }
        }
        
    }
}
