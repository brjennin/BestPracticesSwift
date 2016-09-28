import UIKit
import Quick
import Nimble
@testable import BestPractices

class ApplicationProviderSpec: QuickSpec {
    override func spec() {
        
        var subject: ApplicationProvider!
        
        beforeEach {
            subject = ApplicationProvider()
        }
        
        describe(".sharedApplication") {
            it("returns the shared application") {
                expect(subject.sharedApplication()).to(beIdenticalTo(UIApplication.shared))
            }
        }
    }
}
