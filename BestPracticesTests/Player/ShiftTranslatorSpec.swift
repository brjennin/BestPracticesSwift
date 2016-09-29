import Quick
import Nimble
@testable import BestPractices

class ShiftTranslatorSpec: QuickSpec {
    override func spec() {
        
        var subject: ShiftTranslator!
        
        beforeEach {
            subject = ShiftTranslator()
        }
        
        describe(".translateSlider") {
            it("returns 0.25 when at -2") {
                expect(subject.translateSlider(value: -2)).to(beCloseTo(0.25))
            }
            
            it("returns 0.5 when at -1") {
                expect(subject.translateSlider(value: -1)).to(beCloseTo(0.5))
            }
            
            it("returns 1 when at 0") {
                expect(subject.translateSlider(value: 0)).to(equal(1))
            }
            
            it("returns 2 when at 1") {
                expect(subject.translateSlider(value: 1)).to(beCloseTo(2))
            }
            
            it("returns 4 when at 2") {
                expect(subject.translateSlider(value: 2)).to(beCloseTo(4))
            }
        }
        
    }
}



