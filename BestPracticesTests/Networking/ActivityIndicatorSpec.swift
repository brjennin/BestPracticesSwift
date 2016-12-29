import Quick
import Nimble
@testable import BestPractices

class ActivityIndicatorSpec: QuickSpec {
    override func spec() {

        var subject: ActivityIndicator!

        beforeEach {
            subject = ActivityIndicator()
        }

        describe(".start") {
            it("shows the status bar indicator") {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                subject.start()
                expect(UIApplication.shared.isNetworkActivityIndicatorVisible).to(beTruthy())
            }
        }

        describe(".stop") {
            it("shows the status bar indicator") {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                subject.stop()
                expect(UIApplication.shared.isNetworkActivityIndicatorVisible).to(beFalsy())
            }
        }

    }
}
