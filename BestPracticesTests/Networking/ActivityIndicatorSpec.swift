import Quick
import Nimble
import Fleet
@testable import BestPractices

class ActivityIndicatorSpec: QuickSpec {
    override func spec() {

        var subject: ActivityIndicator!

        beforeEach {
            subject = ActivityIndicator()
        }

        describe(".start") {
            it("shows the status bar indicator") {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                subject.start()
                expect(UIApplication.sharedApplication().networkActivityIndicatorVisible).to(beTruthy())
            }
        }

        describe(".stop") {
            it("shows the status bar indicator") {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                subject.stop()
                expect(UIApplication.sharedApplication().networkActivityIndicatorVisible).to(beFalsy())
            }
        }

    }
}
