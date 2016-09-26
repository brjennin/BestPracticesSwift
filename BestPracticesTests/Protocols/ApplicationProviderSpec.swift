import UIKit
import Quick
import Nimble
import Fleet
@testable import BestPractices

class ApplicationProviderSpec: QuickSpec {
    override func spec() {
        
        var subject: ApplicationProvider!
        
        beforeEach {
            subject = ApplicationProvider()
        }
        
        describe(".sharedApplication") {
            it("returns the shared application") {
                expect(subject.sharedApplication()).to(beIdenticalTo(UIApplication.sharedApplication()))
            }
        }
    }
}
